class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/v3.15.tar.gz"
  sha256 "20760099370ddf7ecb2f92bfdb727def48f6428001165be6ce504264b9a99a0b"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f4f24b7397a122f5dfbbfbe46c9a11b8f4ee873a53f00d8d975993eb89b88614"
    sha256 cellar: :any,                 arm64_ventura:  "60fc78ed51f4d78d9442ce39603a5c6f55802fa4092aa3ecb232e2f7dea46861"
    sha256 cellar: :any,                 arm64_monterey: "43f0235ffb5230b4069abc2b53a0c88a114bc3e79d317247fe7e86dbd5c7d4ff"
    sha256 cellar: :any,                 arm64_big_sur:  "f0edebe4d4485a71c21845dd760b2e6a04deb13179a81935122ed2151313e2d3"
    sha256 cellar: :any,                 sonoma:         "c9a113c46dba4578f4f8c76f879d4a9ef1953574a91f0d0414c3dd073f67babd"
    sha256 cellar: :any,                 ventura:        "39b3dfe20c92afaed1fb94a1acea77a09376494f394be4938a228ec0e5add8ad"
    sha256 cellar: :any,                 monterey:       "6ba610be5b00f1114293d1d0eac272b36609728eda02ba3c6fd741847c68466d"
    sha256 cellar: :any,                 big_sur:        "be0c6bb0acbfe826dca554e8c669d35720257c94bd0184644f4b456451b0c811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8b0a6300a7a5448411828d565b3ab562384880999de7e2f89dc525642eefa9e"
  end

  depends_on "cmake" => :build
  depends_on "open-mpi"

  on_macos do
    depends_on "gcc"
  end

  fails_with :clang do
    cause "needs OpenMP support"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{bin}/interface_test")
    assert_match "edge cut 2", output
  end
end
