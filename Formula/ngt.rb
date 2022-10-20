class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.4.tar.gz"
  sha256 "b8e4f8d1c875210d1f6e929af8757432e84adc28a920168bc2700e72c2e6f64d"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a3a8776edc25b7a03821ae4cb412e180ab69faa8278e7dce68e5ac52c587ea20"
    sha256 cellar: :any,                 arm64_big_sur:  "83455ec6f34c4fda58ca6d83f56a88a8d0cb5ff2bbd9518eca7c0c9f56afa67f"
    sha256 cellar: :any,                 monterey:       "f109b1849053f5ce86807021a7d824b70407ff885a2f36c68e7004ca9af7232c"
    sha256 cellar: :any,                 big_sur:        "7e1f2b9e41c7d36a2d0f17c458567d0e6c1042264e2ffc56976ddc0e5caa8923"
    sha256 cellar: :any,                 catalina:       "e830a477bf240350087dfe08ceda478d46d256596e7aac3fcd7f90da424ad1f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60e3fb1770e8b6119d38236da85a4632ae6b9551f3bf833debd1b01705e0d52d"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
