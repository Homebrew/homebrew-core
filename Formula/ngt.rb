class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.12.tar.gz"
  sha256 "22a328a947276dedb28803993968691fa27cadd3a3c92591b056ce75b9de0f7b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e0d9c4e80a20e9c9911879907442488a8f5f5cd91ada44b1bb0432b3da9994a1"
    sha256 cellar: :any,                 arm64_monterey: "809f65c16a5ca63e390db2ee0ec77efd4ae1f8df41ae9ad1c2c67b9f88cb44f0"
    sha256 cellar: :any,                 arm64_big_sur:  "2a6818bc43e98df3152ff1e79661ec5494b4766f1e7bb89ed8d4ca6bd300edd4"
    sha256 cellar: :any,                 ventura:        "8ed7f45bec70173a92746e55252b29ba60c477ab8f8a945b9179bd79ed17b642"
    sha256 cellar: :any,                 monterey:       "c7fbbb66ee454e22acbec8b803a3f48c07f1939960e067d86d818c65d93cdee9"
    sha256 cellar: :any,                 big_sur:        "dfe2f3a02b79e6f5a9818f257c0c4d53c9268a613863e9e7b5c5760a4d309125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24a1353fe6f52e777ac718e42b3038bf47011cf969601094f161702a7064aa80"
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
