class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/NGT-labs/NGT"
  url "https://github.com/NGT-labs/NGT/archive/refs/tags/v2.8.2.tar.gz"
  sha256 "21a76b3fa337a7da9cfcdb8917f983297e8f768de7757c72c3d65a2377cfa123"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "fc69cfd63e379b54bda2d354a78227a8ddecd567cf815c4fec361dbf8b01e51b"
    sha256 cellar: :any, arm64_tahoe:       "a531f44e212bc38226de7c19644de4060eced88bfb88ff9f0070125ed9f9a884"
    sha256 cellar: :any, arm64_sequoia:     "af00e80275b0f1e523992960db0014aa5b1d95569402698872ffe3db62dc6fae"
    sha256 cellar: :any, arm64_linux:       "0d5e15bb471ec7f25607552173796d07e199aaef09684cf61c57b51c416c4462"
    sha256 cellar: :any, x86_64_linux:      "7f251874b99177c3be8af13995985c128b736f24a188c2372648caa14123e4f0"
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
