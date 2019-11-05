class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.8.0.tar.gz"
  sha256 "a6f9c60dcf7e1bbc4bf1017864f68dca7135f701ae13fab43767ac4bba9d3a7f"

  bottle do
    cellar :any
    sha256 "011722beeedc82f93752810dc50c30d0ab10e66f51d5c63cd1be2f1369a3d053" => :catalina
    sha256 "111fcf226924b96000d9dd223266b6aae21cf21b4a832d0e142e3c5709c326eb" => :mojave
    sha256 "19dc1fb5b7b265f8f1c4bd34c8dd9fb9571ed8b119aea91571590e9fdf784593" => :high_sierra
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
