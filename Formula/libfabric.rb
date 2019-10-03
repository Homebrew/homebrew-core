class Libfabric < Formula
  desc "OpenFabrics libfabric"
  homepage "https://ofiwg.github.io/libfabric/"
  url "https://github.com/ofiwg/libfabric/releases/download/v1.8.1/libfabric-1.8.1.tar.bz2"
  sha256 "3c560b997f9eafd89f961dd8e8a29a81aad3e39aee888e3f3822da419047dc88"
  head "https://github.com/ofiwg/libfabric.git"

  bottle do
    cellar :any
    sha256 "e1387fedf67bc4a6c96e19d6e355943081d941850126c71eb07f0e93a64855b9" => :mojave
    sha256 "fb44b381c8d784f74834b8e7a275dfdf97b1440d0bb8adf2cfd3202a8e65f3d9" => :high_sierra
    sha256 "c3340b70702839124d3ec7b75b868592806cc39ee36fb6b1c0121c6d597ec94b" => :sierra
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
