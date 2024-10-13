class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "7351e5af288fc84a28d3f4612115ca76bf220d0465ae53f6e4b5ecc8111983c5"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "e3b77b6b8d23120f243b5d23eefd462086352fcbc89065fc3c37d978db711062"
    sha256 cellar: :any,                 arm64_sonoma:   "89ccaa1704cea90187aabc187a23e3e8a0ed9f0fd9b3e1f1dac4145b4ff1cfde"
    sha256 cellar: :any,                 arm64_ventura:  "b455dbfb223891bb0e97df7b293ec04fc7c6a0341b074e34fd6ad77cae79c044"
    sha256 cellar: :any,                 arm64_monterey: "b81cb9b4fe0613817012fd8682e67d5b16019d627616a37df4932744a7d29119"
    sha256 cellar: :any,                 sonoma:         "5694b567228f6d35bee96f4c9c64ad556989074aeb98eb121ff909fae3753d94"
    sha256 cellar: :any,                 ventura:        "5e87a237c3b9cbf453cab7891b62429da4a6443a5bdb333d7ecf910a2ecbe719"
    sha256 cellar: :any,                 monterey:       "467be31ee3485b2546ce4d39242373ceaa55f044526a0ea95c43cf790b816dd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488acf984cf15c06962aaaaf8c050a3177a7b2fe56d00f0e266253968736a716"
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
