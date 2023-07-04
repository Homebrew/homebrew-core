class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/v2.0.14.tar.gz"
  sha256 "fdf13dd8058531bb35fda7ac909f89c985bb41c84d1ae49f041be111aecd7803"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "315babda5c85872fc1c8dd24356bf1929d86d6ff5f8963e7a7d04ac0b84f2b6b"
    sha256 cellar: :any,                 arm64_monterey: "6c1300117b3edae57d67649500b61544bb46f99781ee6b8c90aeaee147d4d72c"
    sha256 cellar: :any,                 arm64_big_sur:  "b54b3c862a93337967292feda6580355474395fa80f1875d171bdbc6211ee581"
    sha256 cellar: :any,                 ventura:        "c8391a201c2084ab2a7e9d1de4dcebce4023373e68b3c5fff770f5f2ce09bf14"
    sha256 cellar: :any,                 monterey:       "218cf9b3e837dc0e1b5a348153ebcaedb9163a32547591a927d5e7ab99ac7ba3"
    sha256 cellar: :any,                 big_sur:        "2c1ebb56ce7a4d2a627942a29e6f105e790384366536293551d71f3ee05fb0a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cab4b14dee630c29c2bc65f37753dba3d8235e0e2466f0e22331a7551c75297"
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
