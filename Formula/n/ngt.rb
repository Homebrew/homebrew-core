class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.1.2.tar.gz"
  sha256 "79db09e02ae641da5d426483bbc9d6f5f149fbe9bc199319eb45535af4fb0917"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "85593773d7f377a6bb33213cf8a0a96d3325e5c95e87d9cb890c8fec7682b77a"
    sha256 cellar: :any,                 arm64_monterey: "0989668fd5e00d642d7d922febe2a26e425818eae8f3dbb0e972e6775b29fbe9"
    sha256 cellar: :any,                 arm64_big_sur:  "ab1ce48483bd71bd19be1b25f6ab3d025c5e9d6cf3162359c0295d563aae1440"
    sha256 cellar: :any,                 ventura:        "fec361d6b2bbf4ec868e0d4a3b5fe88d4b3be5a0b89bff545947c21a094a0506"
    sha256 cellar: :any,                 monterey:       "ddc37e57af40bb3b803e272f5f261b6a2c51ae70e69b6262ea40462bfab89769"
    sha256 cellar: :any,                 big_sur:        "30e374c87876e8ba3edf12cf2d0d035ed3a973f6855b3e7e4ebceb9f37d8a0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90edea2f6f42e05e7163ffef27baf097f35583cfe70f62ef002587d9962f3ee8"
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
