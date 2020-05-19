class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.11.5.tar.gz"
  sha256 "b9005a923a5e474b67c395851ba1511cdf099b56710702d434905eb812668f05"

  bottle do
    cellar :any
    sha256 "2c94d14ba60de315fbe650f5088d61e454806c1087a16bfd4d2bd58559e5740e" => :catalina
    sha256 "f3bd23b56cadb1e917b7820b67039974517df2931614002d45978d866ce611d2" => :mojave
    sha256 "d605324f52583c5d8ded4383a00302d1e602d5f2b54d498eac7ea4cd862db399" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
