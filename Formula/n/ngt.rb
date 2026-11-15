class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/NGT-labs/NGT"
  url "https://github.com/NGT-labs/NGT/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "6891814f2b83e6879d6c2e6d835f75fb10a741c8c539293df2d9fd2fab2cecae"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "45abfad53e2ca0728309c68a69567eb65fe32d9abeb9a7191d9f9ee16ea0c546"
    sha256 cellar: :any, arm64_tahoe:       "fd19c1447fd6e4b48ebee8a52c6ad308b534eb8f9f1ac645891b5145e3debe13"
    sha256 cellar: :any, arm64_sequoia:     "e3acfb1afaf5baf2b40d61280af51e3e98d6055c90d80ab9831c68fe99a7fee5"
    sha256 cellar: :any, arm64_linux:       "c381798aa62796327645e3e98b2974c1ffe2e14f3e3c331e41beeaec9bf0545f"
    sha256 cellar: :any, x86_64_linux:      "d12e28e8419b363ffa5a3aff2fdf16b8eb5a477f2b20e99f102d52013e4e0485"
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
