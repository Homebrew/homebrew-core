class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/NGT-labs/NGT"
  url "https://github.com/NGT-labs/NGT/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "37c7538f128f2ee8ce45e93e5a5e22bf2539935a635e4f80a960e4a1b2e29b59"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "68c814bed51b6e1bd6059ab1af9011f9ba5d5abf79420b068cefade03f51f6e5"
    sha256 cellar: :any, arm64_tahoe:       "73cc2257068a41fc0e4b24d49812feeb6cd4f99b7cddd816885d484822f93552"
    sha256 cellar: :any, arm64_sequoia:     "9daeff0a4f46bb36f5097856a48ff99891a1d810f338ee6210936a2e1d26392f"
    sha256 cellar: :any, arm64_sonoma:      "a0164c7bd4e9df6c88bb51999e75a33e95da8c5c04e1ca8b8d4252fcbc559d28"
    sha256 cellar: :any, arm64_linux:       "127ae7b4b02ca58cdddb58f1986f36a54c24776a5694c4a0666f3e234a771553"
    sha256 cellar: :any, x86_64_linux:      "ea501a816f18b1f5658c6532aa1c3c0f2bd23b6bbac1bcf6fdcf3eeb678fdbb1"
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
