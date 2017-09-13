class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.17.0/opensc-0.17.0.tar.gz"
  sha256 "be73c6816867ab4721e6a9ae7dba8e890c5f169f0a2cbb4bf354e0f30a948300"
  head "https://github.com/OpenSC/OpenSC.git"

  bottle do
    sha256 "f3dbc36b378c985b058d27b0f3ce8de474efee88a6baf20ea868b741b3be4b1d" => :sierra
    sha256 "bc4df60a5ce3522c562080ddebd1ff36f1bda21e5fa856ff53ab7b92e3e7d5ee" => :el_capitan
    sha256 "4f0fe7e41fca7a552e58c6cc0968a98ab749c04519531e0e6030f4582f857989" => :yosemite
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
