class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.3.15.tar.gz"
  sha256 "a44b019e97583bbfce41706c474b9b8c304826445d0ef9471f09f3a8111faae6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bf7acaa14502f4c21b9fa4ff25d50d321765d0991f5722171064cf58ee71b5f2"
    sha256 cellar: :any,                 arm64_sonoma:  "4358f3a14fe3015fe7cb6a7c53e61422238286b89d508246440a48c913b42f6a"
    sha256 cellar: :any,                 arm64_ventura: "a879630fb1595e01e2c5ed8eadee2c15eb127dcf0b85f8aa1977a8a6df70ff57"
    sha256 cellar: :any,                 sonoma:        "170faadf6f19e2064059a8c55d9a24f5b168f7c28ac9ed4d2a40fed4ab01da6c"
    sha256 cellar: :any,                 ventura:       "895a69fb8dd9da98186d63206fc78c3736f4eb7d54a3baf62f23581891565eb9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc38f7a3cacf66faaef43cb8ab52e098af2b6025784900ebd51b09b3f12dd1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9776678ad67fa7037676e31bb8ad70f2ca68132b8573b3d95a9537123e538e2c"
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
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
