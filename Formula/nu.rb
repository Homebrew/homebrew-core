class Nu < Formula
  desc "Object-oriented, Lisp-like programming language"
  homepage "https://programming.nu/"
  url "https://github.com/programming-nu/nu/archive/v2.3.0.tar.gz"
  sha256 "1a6839c1f45aff10797dd4ce5498edaf2f04c415b3c28cd06a7e0697d6133342"
  license "Apache-2.0"

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 monterey:     "bceb7b3b986c2b6861645b7044dae295ee1d0cdeefe1af8990accff06bbac370"
    sha256 cellar: :any,                 big_sur:      "f99e9ccd7919c4e2058299e3c545c26ac2fca23a241550fd306afcee6c790d98"
    sha256 cellar: :any,                 catalina:     "d785730e9226dbfe78513a268657bfa50bacd5427b8779f838d00f1c312cc2a8"
    sha256 cellar: :any,                 mojave:       "a3e605c8fca139258b5b5d49f85ac4d57a781017ae0deac8096a74d491219121"
    sha256 cellar: :any,                 high_sierra:  "119f4f3eed1bf677c4e8d0248bd4d042d6c7333d21e6442b90440504bb2e276a"
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
