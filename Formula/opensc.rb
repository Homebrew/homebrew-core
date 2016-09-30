class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.16.0/opensc-0.16.0.tar.gz"
  sha256 "3ac8c29542bb48179e7086d35a1b8907a4e86aca3de3323c2f48bd74eaaf5729"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "a0885f1ba63438d600212f1adf6c1d03bbc7355fc72778d8a21f0c877eaf97be" => :sierra
    sha256 "bf69be51f29b45bd0c5f862560748d30f7d8661002b171a03e78823c73c5eeae" => :el_capitan
    sha256 "1c76d44ec875c6d622a0f6d4ae1f873adb75a789afbe0f2ce3a96231dd3dafd6" => :yosemite
    sha256 "8ef4c4c62042d5db9c6454a1fb050e79ce8ff0081be44483ce2b8b909d701af3" => :mavericks
  end

  option "without-man-pages", "Skip building manual pages"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "docbook-xsl" => :build if build.with? "man-pages"
  depends_on "openssl"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-sm
      --enable-openssl
      --enable-pcsc
    ]

    if build.with? "man-pages"
      args << "--with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl"
    end

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end
end
