class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.8.0.tar.gz"
  sha256 "542e2d6cd4d3013bc4f97843cb1e9521b1b8d8ea72a55c9f5f040857486b0157"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "83b8334d61410e64ce621557f9afed0dbbd6c30c751f841e0b2f8d425b44d919"
    sha256 cellar: :any,                 arm64_monterey: "7302b3051519249325f2bdd16a2bd2ed0cb92b05017993c7f462539ee2873151"
    sha256 cellar: :any,                 arm64_big_sur:  "dc81be5e2aef31e378a8e868310962444dd6f542d1f7c05c378f52e64329999e"
    sha256 cellar: :any,                 ventura:        "111c3669e72047862b642d799cce817e030b155de68e39351b60e68f61f0b7e1"
    sha256 cellar: :any,                 monterey:       "144450ead2c1121981fa88b82a7d0314321e80c9a430eb72dab3562caf299ebe"
    sha256 cellar: :any,                 big_sur:        "9ff10c1ca79d8f7337f7659bf2995af6e8fe6bb33884ad26a6a58ef8a5607989"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d001baf8369d57f65bdeebcc5ce7d0425ecb7b01ab33ab6dadc37379fd5739"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-GNinja", "-DBUILD_SHARED_LIBS=ON"
      system "ninja"
      system "ninja", "install"
    end
    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-loqs", "-o", "test"
    assert_match "operations completed", shell_output("./test")
  end
end
