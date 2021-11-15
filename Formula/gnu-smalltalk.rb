class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  license "GPL-2.0"
  revision 10
  head "https://github.com/gnu-smalltalk/smalltalk.git"

  bottle do
    sha256 monterey: "f68902246ecd9c5e7a3d0f764143fbf870920179294f29377ad3101c1a266b06"
    sha256 big_sur:  "3e29abd9a730f20034a70ae42e217674c85ccf0334a9b2bb45a304cbe4d7c15c"
    sha256 catalina: "730a528feab24da9688e0c8bc1a4176ddab53f92b8d56fc7ff6367bf94710c7c"
    sha256 mojave:   "e23c93c01254dd0be94bf1149b08a1e6df3ed1502f300c3e093dad340b694dbd"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "libffi"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-lispdir=#{elisp}
      --disable-gtk
      --with-readline=#{Formula["readline"].opt_lib}
      --without-tcl
      --without-tk
      --without-x
    ]

    system "autoreconf", "-ivf"
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    path = testpath/"test.gst"
    path.write "0 to: 9 do: [ :n | n display ]\n"

    assert_match "0123456789", shell_output("#{bin}/gst #{path}")
  end
end
