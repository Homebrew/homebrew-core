class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.1.6.tar.gz"
  sha256 "5c6c9a193a22a4d166db812fb5daf4fba487b10d772c1b196eb31839d7af51fb"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d2864b80dfaaad302ecd2b7fe3d5f86a18339eb57bf042e5711dcb55d0b6a74f"
    sha256 cellar: :any,                 arm64_ventura:  "a1820fda0bafd5d7f5553ae486d2c159f2d39f53fc1d71f8ad4922865b7fafe9"
    sha256 cellar: :any,                 arm64_monterey: "1455b030244f63e64166aa46b970af47dbb5bd424d3e0a97e831b0b63ee5a12a"
    sha256 cellar: :any,                 sonoma:         "d3bfe5d5975d7a2cbe9af1ffabf24c8b7772065cbeb4329eea20e9b82b89dca5"
    sha256 cellar: :any,                 ventura:        "f7513822fc906371dbae5b32384959e6a5b9f66bd466a8c01cb4548de51a7ba4"
    sha256 cellar: :any,                 monterey:       "a83360da80811ac1199c54ae81d57591e61348f8726cb091600f7ff20f438c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a36994d8b16f8016200147fb2e26915c55e731563c40543813c0eb288486eb79"
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
