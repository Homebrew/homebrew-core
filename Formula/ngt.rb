class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.9.tar.gz"
  sha256 "61816974ac3e730827b8882a235adbf6d50b9a0af5ae214612b7a79bd02292b1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "334e7cd8b69dbeb351bbe93da9d343ed10aee6edf60669749cdbe59bb988d9b5"
    sha256 cellar: :any,                 arm64_monterey: "f1a547075585b3e8904ab63e89375cc2546ef62b9ebe83d5d751d3e815354b0b"
    sha256 cellar: :any,                 arm64_big_sur:  "fecc394354018813490738c54c59bb1a31cd1b4cde6e8c78276b29812dc301ef"
    sha256 cellar: :any,                 ventura:        "7e67a872ce2760893958bb6df91036715139a634ce468787571c11ebb5568778"
    sha256 cellar: :any,                 monterey:       "1f3b403f8789ad2059d519711a909ec7b368cf363235e453a1af4edcec9ad57a"
    sha256 cellar: :any,                 big_sur:        "529fe1f06cc9ae60882659721db5bd7dbce1e4dc00f56bb52b030c8ca95628e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00f33d965ec2353320be24f9587ab00ced5befa3c2dccad853dd194cd23586ae"
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
