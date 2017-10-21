class Expect < Formula
  desc "Program that can automate interactive applications"
  homepage "https://expect.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/expect/Expect/5.45.3/expect5.45.3.tar.gz"
  sha256 "c520717b7195944a69ce1492ec82ca0ac3f3baf060804e6c5ee6d505ea512be9"

  bottle do
    sha256 "c5abbb16dfe9ff703c9eaf1cebe29a1d1611d3ccd12313525a9a08c0c195c0d0" => :high_sierra
    sha256 "410e1257189d177984dcaabdb5b92aad29aacf7f9ad16d314cf472131d2f329e" => :sierra
    sha256 "862a30f66b267ae389da407174844ee311b0ef4a971e53654f1378da393b5cea" => :el_capitan
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
