class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.7.1.tar.gz"
  sha256 "c8a1ffcfd4facc90916557c0efae9a28c46e803b088d0cb32ee7b0b010555d3a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ae18883dbc2f1a7cef2be0fa53639b3d3622d20989865050372fe5facaced6ee"
    sha256 cellar: :any,                 arm64_big_sur:  "19c321ef0d8849fd71bf1f559cab3eab9ddb312ef15de2af5eeb40b6d07b8dd6"
    sha256 cellar: :any,                 monterey:       "413c2c6b86b61989e040d7c3652863ccf37552d9479cecdf4ded3f7b787768f2"
    sha256 cellar: :any,                 big_sur:        "7ae518ce5f8519e009182f88f6365b306ef6940c892c938312ff82f0dcd4bef4"
    sha256 cellar: :any,                 catalina:       "c304ee2212e895d3a5e0622aeb0dd9c4ee182a4042463b43ef71270ba369e5ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bbefa0b3f582716421ea7eac2a11426252edc323d2e3fbb5e3eb40a24f53ffd"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.1"

  on_linux do
    depends_on "gcc"
  end

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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-loqs", "-o", "test", "test.c"
    assert_match "operations completed", shell_output("./test")
  end
end
