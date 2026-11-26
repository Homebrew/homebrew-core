class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/NGT-labs/NGT"
  url "https://github.com/NGT-labs/NGT/archive/refs/tags/v2.8.3.tar.gz"
  sha256 "38e9783dfba62aee25be22dfca4c587c5da2e9281dda78a8c5f53a2b0fc1c8ca"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4bc480117adf136ac2fbdc55b9c2ecfd2afbb281110a52b95b7ff78123f55f53"
    sha256 cellar: :any, arm64_golden_gate: "1970f5f36ebbae45dd3d02275d3db380f62b56e9c1a7daa1805fea0737a1365f"
    sha256 cellar: :any, arm64_tahoe:       "fa246cb1d7e82d8b0f6c96fcc7a1483caaa96591b201d9e40bf3ebed7053b013"
    sha256 cellar: :any, arm64_sequoia:     "fc6a89385d4477e2849d50bff74c7a524d5b185bce47b87a8edaeaa2ac453b4c"
    sha256 cellar: :any, arm64_linux:       "7c8522b9bf45416a831d61723cc05832fae1a1dedb9fce28e7b7461b70e3f60e"
    sha256 cellar: :any, x86_64_linux:      "77ff6538841cb578a76f0e597c2e43acafef3545d6ee792c5250125dc6b10529"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DNGT_BFLOAT_DISABLED=ON
      -DNGT_MARCH_NATIVE_DISABLED=ON
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
