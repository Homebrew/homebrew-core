class Ngt < Formula
  desc "Neighborhood graph and tree for indexing high-dimensional data"
  homepage "https://github.com/NGT-labs/NGT"
  url "https://github.com/NGT-labs/NGT/archive/refs/tags/v2.7.4.tar.gz"
  sha256 "0faad6f5185e5c66868c8907c4dd91f8776782aa81ba1abaeefe3b0774d6e170"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95e86a836368dd32b795b28cdcb5deaa4e3e70fd03649d8313c8e738fd245aaf"
    sha256 cellar: :any,                 arm64_sequoia: "674e2a599257266ead781e3d9a9a6a7ac0ddeb516852e8d99e2799ed91530e2b"
    sha256 cellar: :any,                 arm64_sonoma:  "44bafbfe3d2cd2ed9c24e1e050364488226c8cefccbd0c3dfcf8e1e24569d58f"
    sha256 cellar: :any,                 sonoma:        "c485400757cb3d361c86393c1f696e8b89f7d80bc4ac3d99606cd1a73b46280d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c38b28dc90ca9400c5c688ae188b1b0e0a9df4ceecbfc54c22402235d3f27f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fef73a749fca9d0d24fe2200a9f7c0f1d46a4cf1c4f679e97d255fae0b7fcc8"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "openblas"
  end

  patch do
    url "https://github.com/NGT-labs/NGT/commit/ddb97ff021bab08b3bae6144d5971a1616e1477c.patch?full_index=1"
    sha256 "3d622749ca18e34c11bb3ef3ffe61e4b534231937e4c0a321b62dec6cf21a3a0"
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
