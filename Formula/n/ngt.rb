class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "1a0df4fd491ea332b7f4fc9d9473867b92f9f9dd2244ed199dfe8218785065c0"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0910f924adac8355c98d7c44992409bfb99d98fdbf2465a9417ecc0780f88622"
    sha256 cellar: :any,                 arm64_ventura:  "9f36036912060ce5b7b2f7d275c8f61205a9a68c38c136dba1a67e5c315d3422"
    sha256 cellar: :any,                 arm64_monterey: "0b58f6d43c57f3a214949f8de8504fb62c3dcb30c1ef13f0008864317d8cb197"
    sha256 cellar: :any,                 sonoma:         "e7effb2a06fdaf40e816ba1e163b7d86c72d660f0ad443849b0d71282c4ece50"
    sha256 cellar: :any,                 ventura:        "16fdbfc64a0de172f00079a0671040d857a457c441ca84430034711aef413b5c"
    sha256 cellar: :any,                 monterey:       "9c080df0bea9e64017a807a72099d1910f39006b641ad33dbad6ae752fa6512a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2651b1ba923c9053ecdfd3b68336919f97a8b327e150d004c9742b7eaa9ce947"
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
    system "#{bin}/ngt", "-d", "128", "-o", "c", "create", "index", "data/sift-dataset-5k.tsv"
  end
end
