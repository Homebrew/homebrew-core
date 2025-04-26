class Kahip < Formula
  desc "Karlsruhe High Quality Partitioning"
  homepage "https://algo2.iti.kit.edu/documents/kahip/index.html"
  url "https://github.com/KaHIP/KaHIP/archive/refs/tags/v3.19.tar.gz"
  sha256 "ab128104d198061b4dcad76f760aca240b96de781c1b586235ee4f12fd6829c6"
  license "MIT"
  head "https://github.com/KaHIP/KaHIP.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e35ec707621f77c3931c1ea5a1fc5391aca68b6b17ccd0c2a0939bdc55efd0b5"
    sha256 cellar: :any,                 arm64_sonoma:  "70237608f0031ea32bc841583f0f2bd6541b68db482cd91b635b3cbf84375796"
    sha256 cellar: :any,                 arm64_ventura: "b694039fe2f48ddc68966e89b6fbcbc09864eb2bcc3e88edcf38f9da66ccb74a"
    sha256 cellar: :any,                 sonoma:        "8d60453b8a94e0ade7f3d3548bc557a0dfd81cead02ad90743fdea32e00ac510"
    sha256 cellar: :any,                 ventura:       "0d3b5371c8287d213dfcb1b3414885dd7bd52e1736f6ac4f3c3c27f10468408b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18f3208834cbc20617007ced155eaa640defb1a5a25f9f985226eff7d6278678"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4b05fc30581f8d2d30972c19d088a25980d69eaf81e657c0f54321a146add5"
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
