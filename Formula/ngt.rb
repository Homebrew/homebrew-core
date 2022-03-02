class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v1.14.3.tar.gz"
  sha256 "e3a2c6085001bf9183d214f93aa1ed89ac10ce93c2327799ca8e5d8c10a8edf1"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9c10cc279964217b5f37d2907b82395630ea9a4528ef7142e75f562ee6451604"
    sha256 cellar: :any,                 arm64_big_sur:  "3ccafd7ff3b8b82d91c58ab0142e24c9f1f29c760e87b8ab8268fc91f32b37a8"
    sha256 cellar: :any,                 monterey:       "871dd786b9a6cd9f3198d32b87f58a079fdc648a3c3ee524353a23ed80bfa593"
    sha256 cellar: :any,                 big_sur:        "172e1ef3707b4857450db5bdc02d681ab74ca0ac638f3b491aaf74497af91c29"
    sha256 cellar: :any,                 catalina:       "a9477f72a46e3c3688ecd49a05ebc2199c8978da10694bebadf5bce797281f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a9bf76755b4785f764ca6ca601791a6990dadeb252cedfad80240fda7a4db95"
  end

  depends_on "cmake" => :build
  depends_on "libomp"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
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
