class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.9.0.tar.gz"
  sha256 "705cdb5afaba7ea4948785499162f8a0331274e2ea5b822570e7505aae1db543"

  bottle do
    cellar :any
    sha256 "d80e3040720c7f35c43bf9270141e0b10cf7313107af35ae088ddd6ca205174d" => :catalina
    sha256 "288fdb59156ddf7819f259657d43c860c1a9cfdbe2ac38daa0d7953cff4e6a6b" => :mojave
    sha256 "fb50c0927a8a06dff04acc1512acf980bc65819eda8b11776b077e242e116ee1" => :high_sierra
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
