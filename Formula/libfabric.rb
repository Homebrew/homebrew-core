class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.10.0/libfabric-1.10.0.tar.bz2"
  sha256 "c1ef6e9cd6dafec3f003d2f78f0f3a25f055a7a791e98b5a0db1e4c5036e40f6"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "87fc1c6f94b6b9941c38e6803d3f09b26dc5be18cb76c91f60a70c564ded6b1e" => :catalina
    sha256 "a20ac83b033d5d5ac9c85cab4562abe1374690cd1d7f08934d28e2513e62b193" => :mojave
    sha256 "ff81fb4106045c7e764ea17190cf78a7e7d9333ac5045ea3153b07ce87a210be" => :high_sierra
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
