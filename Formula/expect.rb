class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://expect.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.3/expect5.45.3.tar.gz"
  sha256 "c520717b7195944a69ce1492ec82ca0ac3f3baf060804e6c5ee6d505ea512be9"

  bottle do
    sha256 "f49994bf93a0d51de030ef15a07c8b31c7abd04241054cc831cbbdeb442b81b4" => :high_sierra
    sha256 "25b09bc0dbb7c9550df75b6d6d84c7c5444bbb9ea508fb19f043f01b1c2b0f90" => :sierra
    sha256 "53c9bc7b8884ac782dcd374d66192e9e60e33e478568593df029bf6e65667b31" => :el_capitan
    sha256 "ffe25ca3a637bee0ff0bb49ce17283d2f64d6c1e1636db3c4c4de08badbd6bb0" => :yosemite
  end

  option "with-threads", "Build with multithreading support"
  option "with-brewed-tk", "Use Homebrew's Tk (has Cocoa and threads support)"

  deprecated_option "enable-threads" => "with-threads"

  depends_on "tcl-tk" if build.with? "brewed-tk"

  # Autotools are introduced here to regenerate configure script. Remove
  # if the patch has been applied in newer releases.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --enable-shared
    ]
    args << "--enable-threads" if build.with? "threads"
    args << "--enable-64bit" if MacOS.prefer_64_bit?

    if build.with? "brewed-tk"
      args << "--with-tcl=#{Formula["tcl-tk"].opt_prefix}/lib"
    else
      ENV.prepend "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework/Versions/8.5/Headers/tcl-private"
      args << "--with-tcl=#{MacOS.sdk_path}/System/Library/Frameworks/Tcl.framework"
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
