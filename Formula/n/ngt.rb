class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/yahoojapan/NGT"
  url "https://github.com/yahoojapan/NGT/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "77d085c47b9e0b7c60b658781f9719b5cbfccf92468b820875ae25f5a67808c6"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "00a70c66e53987f62692fb48ea750afe6344663f653a229541736607181ed836"
    sha256 cellar: :any,                 arm64_sequoia: "ca6328b8842370642575edf299320134ff4aae8407af90a4dfd36ec3f4fa1602"
    sha256 cellar: :any,                 arm64_sonoma:  "06ef432570e37242816977cc9214051f40697641960d279e9ee2c38744920292"
    sha256 cellar: :any,                 arm64_ventura: "0405420d040dde5f267c8f78542471500de7411a69ccba386d9947287688edca"
    sha256 cellar: :any,                 sonoma:        "dff5c96c811f96b18f59a5400a9846e2fddcb307e5570a0e6601a726f3c810da"
    sha256 cellar: :any,                 ventura:       "dfd4740e2dc6d3c269f7a2ff1d4b0f817e2bd605dd025bb3fca7d3aabf92da36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "627b8b4b9467e87b64f39e8f6a88e850f6ffcc1120fbfe8f5afb1342f5c4e631"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dd155335d1db5ea8dc9c1085c757970152743ea60f8a4645a931a4bc50ef5c8"
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
