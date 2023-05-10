class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.11.tar.gz"
  sha256 "082c9c67f8e070cfad9fe264807e1848a66ff8f80852c076a6ba97fcf8b24f4a"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c34c1157ff94b11bc8c2044a63674bfb6cd093b8efe5d1119e2f71662223c21a"
    sha256 cellar: :any,                 arm64_monterey: "d07ac1068820b3379f433a43889b2ba72840a9a34a2415f4c309f133f0c9364b"
    sha256 cellar: :any,                 arm64_big_sur:  "069b0efb0cc740ea80942681e1b926f2d2f6a6e107018b6771978bb6bec4182e"
    sha256 cellar: :any,                 ventura:        "36f2b1ae70938e87ab7d9d49870e9df4ff6b8cee8183825404af8c75e551d0ac"
    sha256 cellar: :any,                 monterey:       "9e1d45d9070c9c8d61847ec0b2216aa172c05015f680098edf177a825a464308"
    sha256 cellar: :any,                 big_sur:        "11174569d905c8659ccbc377facca8056c8608d4a12545c65b81e8b374e6f17f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a35e1f52148027aa1ce944192c35bbf1c1044e85d4a7bd4035abc9b58e075ac"
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
