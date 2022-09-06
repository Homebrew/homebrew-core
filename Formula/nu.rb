class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://programming.nu/"
  url "https://github.com/programming-nu/nu/archive/v2.3.0.tar.gz"
  sha256 "1a6839c1f45aff10797dd4ce5498edaf2f04c415b3c28cd06a7e0697d6133342"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 monterey:     "a2a1bdb6473b6afd30cde5def27158415fb38f92851b8a252498631f7e2f350d"
    sha256 cellar: :any,                 big_sur:      "bde3090df08b5cf2a6038aab4b80daf3981fcf2d7cb19653a8bb507eb5a2349a"
    sha256 cellar: :any,                 catalina:     "4cace319187e0c057a0437dd17f83022e9e5ac20f478cc317fd2be8b2ca8c2ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1413e8674c855798fc973e5f9a00af4575e6fece5427e1f16b8814e40c338cf2"
  end

  depends_on "pcre"

  uses_from_macos "llvm" => [:build, :test]
  uses_from_macos "swift" => :build # For libdispatch on Linux.
  uses_from_macos "libffi"

  on_linux do
    depends_on "gnustep-make" => :build
    depends_on "gnustep-base"
    depends_on "libobjc2"
  end

  # Clang must be used on Linux because GCC Objective-C support is insufficient.
  fails_with :gcc

  def install
    ENV.delete("SDKROOT") if MacOS.version < :sierra
    ENV["PREFIX"] = prefix
    # Don't hard code path to clang.
    inreplace "tools/nuke", "/usr/bin/clang", ENV.cc

    unless OS.mac?
      ENV.append_path "PATH", Formula["gnustep-make"].libexec

      # Help linker find libdispatch from swift on Linux.
      # This is only used for the mininush temporary compiler and is not needed for nush.
      ldflags = %W[
        "-L#{Formula["swift"].libexec}/lib/swift/linux"
        "-Wl,-rpath,#{Formula["swift"].libexec}/lib/swift/linux"
      ]
      ENV["LIBDIRS"] = ldflags.join(" ")

      # Remove unused prefix from ffi.h
      inreplace ["objc/NuBridge.h", "objc/NuBridge.m", "objc/Nu.m"], "x86_64-linux-gnu/", ""

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
    system "make"
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
