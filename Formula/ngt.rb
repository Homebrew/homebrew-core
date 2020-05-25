class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.11.6.tar.gz"
  sha256 "d7449e4486efd8819288f62fe274193a694a2d3ecb27461122bbb3f8cb877987"

  bottle do
    cellar :any
    sha256 "20d71e74645162639a39d01bc330ebbefc206ae9843874e02368cfc16dbd1fb4" => :catalina
    sha256 "a1e3b0587ac31a96e95e8fa4e60ccd21f8557c0056713e005c32dfba29289590" => :mojave
    sha256 "cf9f8ce62237595c58f6fdd171ad5ad1fdbcaacb58c47112fab9172a3f5f28de" => :high_sierra
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
