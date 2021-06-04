class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.5.0.tar.gz"
  sha256 "f677ea45ada4a1e97354bf2e734047ca6efe6183498224d8fc47b8b88c63a6b5"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "12587ae63bddf86a3dfd68b4983e7b8957b0cc7edb194fe52ce1b111d7d53110"
    sha256 cellar: :any, catalina: "7d917692f71d83f31df548ccd060a66dca0fb3abbf2e432f831e664e01073126"
    sha256 cellar: :any, mojave:   "36d6d353e7c10b3ba42fd2afb9e3a4bbf4a61a2611ad13c39bec0c88e0fcea58"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.1"

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
