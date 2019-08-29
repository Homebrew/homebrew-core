class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz"
  sha256 "2c5a0e4df9027635290b9c0f3addbbf0d651db5ddb0ab789cb0e978f02fd5826"
  revision 1
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "75862725aed348f1f4dce78e71a384c6b5439cd7487e77710494fe66ac430ea0" => :mojave
    sha256 "407bc8be487da4744b24fb2a5e931a2b0397a5376b17350771df3328a99a9fa3" => :high_sierra
    sha256 "d0f61b74690cd648f36acc10890372688c84ac231fa9456193121a60fbc0d980" => :sierra
    sha256 "e265daf4221e14d23b6a8a82d657a87bd4c5291a0577b43ca5377a08a0f19f09" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end
end
