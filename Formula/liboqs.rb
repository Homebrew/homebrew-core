class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.7.0.tar.gz"
  sha256 "7a2b01d33637869b02475c5a7b3b31e8f7cebce491877719f27954a89f6d764e"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d1ad7ba88ddfa6fcca40f6d25ab51dfee332da4668d6ac16dca8a759aeacb96e"
    sha256 cellar: :any, arm64_big_sur:  "7f970fb9bebb1c552ddd4c0e7abb2916a023bf530f7f53356574e80443d63acc"
    sha256 cellar: :any, monterey:       "34676cda65de128c716eab909eb98203715bf2444ae1d9e56cb02a3723985525"
    sha256 cellar: :any, big_sur:        "db585740f314adb4728ac5964e2a65495c77b5db01f260b3eb6140d61cfb29d3"
    sha256 cellar: :any, catalina:       "4580d66dbd428f4851200f1800331b5b33b534677026312bfac4731a6d94f29c"
    sha256 cellar: :any, mojave:         "c621f7603b90315a0605d56c6373f6d8542117e03512585153a7696e2349559e"
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
