class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.4.2.tar.gz"
  sha256 "728a97cb136d7f623c8dc77b24117972d32ccef23e3d857248c4fa065fde4fed"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fc98ef0b336fad132afe1813df78de725ecc70d9bbb7c5ebe75735a3c81eb69a"
    sha256 cellar: :any,                 arm64_sonoma:  "444bd0278f64d2f80cc6bda4a075aa63442f3122cba611048382435764945677"
    sha256 cellar: :any,                 arm64_ventura: "0478eec6c88c2d7ac4efe1146ed5850ba7c2bbb1bc7b7757926f1f8fbdf3e8bb"
    sha256 cellar: :any,                 sonoma:        "88b771a6f2b9ad8840d3d4eceee2ae8a3aa04a83ef0b2ac699824b79174b60bc"
    sha256 cellar: :any,                 ventura:       "483952949b2c680e74bac746d668a35a761f63f73e0a7b946b11008dd2caef57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43490875f943192073f0210c9661fa07b8eb002d53512d93f8328efe77d36461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7009d18a4794d9c0fce5b1a6d6cd141ee2b94202054ea425c4723617fcfa7064"
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
