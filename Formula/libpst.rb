class Libpst < Formula
  desc "Utilities for the PST file format"
  homepage "http://www.five-ten-sg.com/libpst/"
  url "http://www.five-ten-sg.com/libpst/packages/libpst-0.6.72.tar.gz"
  sha256 "8a19d891eb077091c507d98ed8e2d24b7f48b3e82743bcce2b00a12040f5d507"
  revision 1

  bottle do
    cellar :any
    sha256 "0e97a5313eb5bb39daf62fca974333b69a0cb03ee6602820b5bfa0702c44a7c2" => :mojave
    sha256 "e7b74eccf8c9929f6f6673a3064dadcfc4eb7b63d43776920c9733ebc01af7a5" => :high_sierra
    sha256 "bfa351efefe41b8a3726c616fe6d9f1e8d920902cccb36d23f530ae28d2a9522" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python"
  depends_on "gettext"
  depends_on "libgsf"
  depends_on "python@2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-python
      --with-boost-python=mt
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"lspst", "-V"
  end
end
