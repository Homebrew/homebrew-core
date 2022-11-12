class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.5.tar.gz"
  sha256 "aa2d5845edde04dc7d91cd14cc3d315535c9438e298f241c79fbdd0b0a7ff4cf"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e90ae52ad1d59b1c759cb86dd38d189a7faed6eaaddeb12d596a1c8492ab884"
    sha256 cellar: :any,                 arm64_monterey: "700b0b3d5dd627a6e55db8e546110ccff7339e038e54f57a6d3fd666e8019af1"
    sha256 cellar: :any,                 arm64_big_sur:  "439a65a895c848583271fbeb4c05afbd854ae7ebc12260ac6d5aced6f06e122c"
    sha256 cellar: :any,                 monterey:       "f24082a32f42e2589c85cae3a4900f6afbd5ec1a903e1ce46e21e81dbb88114f"
    sha256 cellar: :any,                 big_sur:        "f96ab14ab124dcd329b694820ddfeacf277aea8389c90669eb9f697442306c78"
    sha256 cellar: :any,                 catalina:       "89896de0068fa4b921f2c2c8beef0ae2e58e5785b4b499703ea6729b033d2efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93395c3cfbc0c03efb29e4e0ad1a1e703b6947cffd4d8f9a3a25d9aad9f12fc4"
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
