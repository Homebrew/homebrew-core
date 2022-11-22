class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7787effb1d545e3e6da3dbfae2d7fe4dc88c6a0e5561e2999eabacc6311ab398"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9800614b18342c14efb5e9edd4ccbb352e3f20a119451aea7720b1230e4dbb83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b463fc71f770cd18f42ddb727cc628036df281bbc07ab5d0173f10f9377571c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9afe79ecfce07215d78d9c82bcfd02ee438922f9573ba10a4657f95098d979b"
    sha256 cellar: :any_skip_relocation, ventura:        "bd577891e953b883fa69df7e270f7fa06ce3a5478f28f5396a7bcf6a8b8c01ec"
    sha256 cellar: :any_skip_relocation, monterey:       "4b82dd5397126bb90a23c6055dc5ab985c4a71c5129cf3a8314bf0f2efa55579"
    sha256 cellar: :any_skip_relocation, big_sur:        "35b0bbc0e331ebf20552a8232ed08b78e6a80e087769079fb91bb76527f5244d"
    sha256 cellar: :any_skip_relocation, catalina:       "16c1b71bb9e01c74306e1474fa7b2388953f2b0b154381bdb35020b430e24191"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85d263f015a75269c748d45945cddc7d6bb745ad4fa9a62e08fff521a4afb92c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end
