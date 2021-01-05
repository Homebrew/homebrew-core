class GnuSmalltalk < Formula
  desc "Implementation of the Smalltalk language"
  homepage "https://www.gnu.org/software/smalltalk/"
  url "https://ftp.gnu.org/gnu/smalltalk/smalltalk-3.2.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/smalltalk/smalltalk-3.2.5.tar.xz"
  sha256 "819a15f7ba8a1b55f5f60b9c9a58badd6f6153b3f987b70e7b167e7755d65acc"
  license "GPL-2.0"
  revision 9
  head "https://github.com/gnu-smalltalk/smalltalk.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "9fc21dd5d9f30b200c1d4b1187a22663f100ac4db1363e86edc12d59db96cd43" => :big_sur
    sha256 "8a00e81f1a751efeec308de2bbf2e75a1173a636a29c27cec440c121208f0fe6" => :catalina
    sha256 "0f569ca28ff2eaa54b36780c278a7170be42ef25e6d305852323952390be7270" => :mojave
    sha256 "2f369eed3ac62fbe0c4c257cefa0c9477ce0a806859a18d65ba565fbfdc76786" => :high_sierra
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
