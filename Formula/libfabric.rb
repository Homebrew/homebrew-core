class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.7.1/libfabric-1.7.1.tar.bz2"
  sha256 "f4e9cc48319763cff4943de96bf527b737c9f1d6ac3088b8b5c75d07bd719569"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "483e8c6e48acf3788b3ca565881b025f8478cf0784d19223633e0a7e93577031" => :mojave
    sha256 "a8d5492119ac2e7496230e562eeaee9c2c54497fe00797b5b1250c246a907923" => :high_sierra
    sha256 "74312d87d7fb9073b7b339d74d96a36de0c6ab38578775e3b4015b8207f16a65" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#(bin}/fi_info"
  end
end
