class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.4.3.tar.gz"
  sha256 "76c0d44330ae28eed76c07f2d54562da124157a125f34f421b4923504703e698"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ad5b612b95d41ad915ea76831dcb40662bb701e27d91298397bcdff9ded65c7c"
    sha256 cellar: :any,                 arm64_sonoma:  "d489117295732b67a9a998c2817b7567904dd4b38a6faf94781fa6695c36ffe7"
    sha256 cellar: :any,                 arm64_ventura: "73536d766b65e7c6073adbf9f4cc1ff05e87962914d7c8aa58b38d120584d2b4"
    sha256 cellar: :any,                 sonoma:        "055730e996b8a6fa6b1033da71777d5224616db5bf6c826abdd8cc595bc5b1b4"
    sha256 cellar: :any,                 ventura:       "07068d285455079f1bb5ef03ddb31df1f44b2615d4458d12c9b92397e81f53f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ef5fc460c238553a56cc506276061c6979aac07c02b1e1e75e735776f34a03c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66799a7d41079777438b8788d5e77dc46f229a9c2a1683c32287c4a5d79e8eef"
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
