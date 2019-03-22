class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.7.0/libfabric-1.7.0.tar.bz2"
  sha256 "b3dd9cc0fa36fe8c3b9997ba279ec831a905704816c25fe3c4c09fc7eeceaac4"
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
