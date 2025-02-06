class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.11.tar.gz"
  sha256 "81bdf5c47cbc66e0489c87c414ca1d844da9ddd006d4d44fa0fa5c256bcc5bdd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1b2bcf7d7899b670018209c8ba3e160aad58b33fc22ba9dc9a91d2cb3a6cc9ce"
    sha256 cellar: :any,                 arm64_sonoma:  "db3d2b32c86b046b33000b0edc7a71ecac5ada963b6424f6fc047258cdcc2fff"
    sha256 cellar: :any,                 arm64_ventura: "3b7c13ef15ce44d45171e775fec42c2e2628963725427e261597ba3f551a0aa5"
    sha256 cellar: :any,                 sonoma:        "517680b9b993ff74b51b38e0f79d3ab7a48de48f5f2aa4b60b988b2f4996e9b4"
    sha256 cellar: :any,                 ventura:       "2ad9ee896cc5aedf1145ca5caf5e76d2f371abe68829e49d24f0ba1af80eddd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23de45076c70e7e798c7723a8473469a3af6c704b5441ea5b09e8c15bf8aa4f7"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "data"
  end

  test do
    cp_r (pkgshare/"data"), testpath
    system bin/"ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
