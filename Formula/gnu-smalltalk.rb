class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  license "GPL-2.0"
  revision 10
  head "https://github.com/gnu-smalltalk/smalltalk.git", branch: "master"

  bottle do
    rebuild 1
    sha256 ventura:      "0d0749c9612ed7111d1e923e6cdee688f5aa2943dfbd45a62ab4701074b06fcf"
    sha256 monterey:     "a1fc98f122660e0bcf6005eb04cdc7ab941e4e44ee888ca20de10a411f1d2938"
    sha256 big_sur:      "3de7522ec83425a3ad683f0050298630d3a1dfe4065cd5f57c8e18e266e434d8"
    sha256 catalina:     "b389791ed3f702f317883b54421e9a47122326607b603a592dd5903a057ff344"
    sha256 x86_64_linux: "d10915dea08be1b60576263f619653fca70471bfa64a07f1a0d73eac94055362"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "pkg-config" => :build
  depends_on "gdbm"
  depends_on "gnutls"
  depends_on "libsigsegv"
  depends_on "libtool"
  depends_on "readline"

  uses_from_macos "zip" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "zlib"

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
