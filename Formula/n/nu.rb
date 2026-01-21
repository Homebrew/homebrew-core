class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://programming.nu/"
  url "https://github.com/programming-nu/nu/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "1a6839c1f45aff10797dd4ce5498edaf2f04c415b3c28cd06a7e0697d6133342"
  license "Apache-2.0"
  revision 4
  head "https://github.com/programming-nu/nu.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b58a4f88db0117eae2d986cfb083129c6247b160f4a79f45d8af94b32a557ec1"
    sha256 cellar: :any, arm64_sequoia: "d3bb01d2370d369f17fc335866e16b316332705eb82ac79c9ec5572abefc3dba"
    sha256 cellar: :any, arm64_sonoma:  "69497e945208739a28df606a1378a92c58df44126be188d8326e4d9a2dd19d58"
    sha256 cellar: :any, arm64_ventura: "f1ba59236538e76c7c7dcd66e99e644c959ba55ecaae3f04bb3c38d0f6d1727f"
    sha256 cellar: :any, sonoma:        "b2c929078f30bbd7c3dd6fe407323a86df1b525d87980ce87828dfb8f2dd9ad0"
    sha256 cellar: :any, ventura:       "f193d95cab2271ca80753f5ec2915e54b70eeb60200f56f82bea6a0dbd59098c"
    sha256               x86_64_linux:  "e574e9a1043c30df8da1995fb0d344271e4d2f3cd92815a57a3ddbf420a8f794"
  end

  # Last release on 2019-07-29. Needs multiple workarounds/hacks and uses EOL `pcre`
  deprecate! date: "2025-10-29", because: :unmaintained
  disable! date: "2026-10-29", because: :unmaintained

  depends_on "pcre"

  uses_from_macos "llvm" => :build
  uses_from_macos "swift" => :build # For libdispatch on Linux.
  uses_from_macos "libffi"

  on_linux do
    depends_on "gnustep-make" => :build
    depends_on arch: :x86_64 # fails to build on arm64 linux
    depends_on "gnustep-base"
    depends_on "libobjc2"
    depends_on "readline"
  end

  on_arm do
    # objc/NuBridge.m:1242:6: error: implicit declaration of function 'ffi_prep_closure' is invalid in C99
    # Since libffi.tbd only exports '_ffi_prep_closure' on x86_64, we need to use formula until fixed.
    # Issue ref: https://github.com/programming-nu/nu/issues/97
    depends_on "libffi"
  end

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  # Fix Snow Leopard or Lion check to avoid `-arch x86_64` being added to ARM build
  # PR ref: https://github.com/programming-nu/nu/pull/101
  # TODO: Remove if upstream PR is merged and in a release.
  patch do
    url "https://github.com/programming-nu/nu/commit/0a837a407f9e9b8f7861b0dd2736f54c04729642.patch?full_index=1"
    sha256 "6c8567f0c2681f652dc087f6ef4b713bcc598e99729099a910984f9134f6a72c"
  end

  # Fix missing <readline/history.h> include in objc/NuParser.m
  # Build failure details: https://github.com/Homebrew/homebrew-core/pull/126905#issuecomment-1487877021
  # PR ref: https://github.com/programming-nu/nu/pull/103
  # TODO: Remove if upstream PR is merged and in a release.
  patch do
    url "https://github.com/programming-nu/nu/commit/fdd7cfb3eaf4c456a2d8c1406526f02861c3f877.patch?full_index=1"
    sha256 "d00afd41b68b9f67fd698f0651f38dd9da56517724753f8b4dc6c85d048ff88b"
  end

  def install
    ENV["PREFIX"] = prefix
    # Don't hard code path to clang.
    inreplace "tools/nuke", "/usr/bin/clang", ENV.cc
    # Work around ARM build error where directives removed necessary code and broke mininush.
    # Nu uncaught exception: NuIvarAddedTooLate: explicit instance variables ...
    # Issue ref: https://github.com/programming-nu/nu/issues/102
    inreplace "objc/NuOperators.m", "#if defined(__x86_64__) || TARGET_OS_IPHONE",
                                    "#if defined(__x86_64__) || defined(__arm64__)"

    unless OS.mac?
      ENV.append_path "PATH", Formula["gnustep-make"].libexec

      # Help linker find libdispatch from swift on Linux.
      # This is only used for the mininush temporary compiler and is not needed for nush.
      ldflags = %W[
        "-L#{Formula["swift"].libexec}/lib/swift/linux"
        "-Wl,-rpath,#{Formula["swift"].libexec}/lib/swift/linux"
      ]
      ENV["LIBDIRS"] = ldflags.join(" ")

      # Remove CFLAGS that force using GNU runtime on Linux.
      # Remove this workaround when upstream drops these flags or provides a way to disable them.
      # Reported upstream here: https://github.com/programming-nu/nu/issues/99.
      inreplace "Nukefile", "-DGNU_RUNTIME=1", ""
      inreplace "Nukefile", "-fgnu-runtime", ""
    end

    inreplace "Nukefile" do |s|
      s.gsub!('(SH "sudo ', '(SH "') # don't use sudo to install
      s.gsub!("\#{@destdir}/Library/Frameworks", "\#{@prefix}/Frameworks")
      s.sub!(/^;; source files$/, <<~EOS)
        ;; source files
        (set @framework_install_path "#{frameworks}")
      EOS
    end

    # Remove bundled libffi
    rm_r(buildpath/"libffi")

    # Remove unused prefix from ffi.h to match directory structure of libffi formula
    include_path = (OS.mac? && Hardware::CPU.arm?) ? "ffi" : "x86_64-linux-gnu"
    inreplace ["objc/NuBridge.h", "objc/NuBridge.m", "objc/Nu.m"], "<#{include_path}/", "<"

    system "make", "CC=#{ENV.cc}"
    system "./mininush", "tools/nuke"
    bin.mkdir
    lib.mkdir
    include.mkdir
    system "./mininush", "tools/nuke", "install"
  end

  def caveats
    on_macos do
      <<~EOS
        Nu.framework was installed to:
          #{frameworks}/Nu.framework

        You may want to symlink this Framework to a standard macOS location,
        such as:
          ln -s "#{frameworks}/Nu.framework" /Library/Frameworks
      EOS
    end
  end

  test do
    system bin/"nush", "-e", '(puts "Everything old is Nu again.")'
  end
end
