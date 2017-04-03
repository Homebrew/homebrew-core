class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://expect.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45/expect5.45.tar.gz"
  sha256 "b28dca90428a3b30e650525cdc16255d76bb6ccd65d448be53e620d95d5cc040"

  bottle do
    sha256 "25b09bc0dbb7c9550df75b6d6d84c7c5444bbb9ea508fb19f043f01b1c2b0f90" => :sierra
    sha256 "53c9bc7b8884ac782dcd374d66192e9e60e33e478568593df029bf6e65667b31" => :el_capitan
    sha256 "ffe25ca3a637bee0ff0bb49ce17283d2f64d6c1e1636db3c4c4de08badbd6bb0" => :yosemite
  end

  option "with-threads", "Build with multithreading support"
  option "with-brewed-tk", "Use Homebrew's Tk (has optional Cocoa and threads support)"

  deprecated_option "enable-threads" => "with-threads"

  depends_on "tcl-tk" if build.with? "brewed-tk"

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fix Tcl private header detection.
  # https://sourceforge.net/p/expect/patches/17/
  patch do
    url "https://sourceforge.net/p/expect/patches/17/attachment/expect_detect_tcl_private_header_os_x_mountain_lion.patch"
    sha256 "bfce1856da9aaf5bcb89673da3be4f96611658cb05d5fbbba3f5287e359ff686"
  end

  def install
    args = ["--prefix=#{prefix}", "--exec-prefix=#{prefix}", "--mandir=#{man}"]
    args << "--enable-shared"
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    if build.with? "brewed-tk"
      args << "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib"
    else
      ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers/tcl-private"
      args << "--with-tcl=#{MacOS.sdk_path}/usr/lib"
    end
    # Regenerate configure script. Remove after patch applied in newer
    # releases.
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", *args
    system "make"
    system "make", "install"
    lib.install_symlink Dir[lib/"expect*/libexpect*"]
  end

  test do
    system "#{bin}/mkpasswd"
  end
end
