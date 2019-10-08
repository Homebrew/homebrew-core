class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.19.0/opensc-0.19.0.tar.gz"
  sha256 "2c5a0e4df9027635290b9c0f3addbbf0d651db5ddb0ab789cb0e978f02fd5826"
  revision 1
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "aef1ca8666ec50558f3631d98cb1985570b751e54d6fc6d44679ebdfdb917a33" => :mojave
    sha256 "b27e321b2255e7b97efd3e1ac45c2a51264f84a6cca581da533dc28ea95c197b" => :high_sierra
    sha256 "f6cb9f0abe5a48c71d8c0adc00a741bcac48807a272f712ae7685b74da8535fe" => :sierra
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
