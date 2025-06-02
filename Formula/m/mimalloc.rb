class Mimalloc < Formula
  desc "Compact general purpose allocator"
  homepage "https://github.com/microsoft/mimalloc"
  url "https://github.com/microsoft/mimalloc/archive/refs/tags/v3.0.3.tar.gz"
  sha256 "baf343041420e2924e1760bbbc0c111101c44e1cecb998e7951f646a957ee05f"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b657c7aca154a9b170620ac048e5debd9f0b851408136e9d3491e70649492947"
    sha256 cellar: :any,                 arm64_sonoma:  "cb4094377d756f2611176257b1110e6e965990c2ae2472411031e9493975c16a"
    sha256 cellar: :any,                 arm64_ventura: "417efc86d46f48ce567097aaeeb1520953a01757aab9e419bedf5912076187c5"
    sha256 cellar: :any,                 sonoma:        "55982e35a14e02cb0520d13f785bf7b120c5f85d6c1ba5d20bd4875c93724f5f"
    sha256 cellar: :any,                 ventura:       "1ab149295b0719eb3f7fa08c5b6729bc8dfa81ab053e4f906e004fbea4300f5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60df33e9543a3f69549eea7e959c2358bf55804e9e4a1cfe7e90513e74a740b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbadee26452799c56fbdb76c6a5da92852b2332cab14be7da3b4e26be484f145"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DMI_INSTALL_TOPLEVEL=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp pkgshare/"test/main.c", testpath
    system ENV.cc, "main.c", "-L#{lib}", "-lmimalloc", "-o", "test"
    assert_match "heap stats", shell_output("./test 2>&1")
  end
end
