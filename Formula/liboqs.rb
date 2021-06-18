class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.6.0.tar.gz"
  sha256 "a3fccc064327c688c10437223ef06b6358016b50c3b7e20900ad551c3ae01741"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, big_sur:  "6676a7fd26d13f5a67251d628afde7aca5d22a592294a26e3ec032a0f3623659"
    sha256 cellar: :any, catalina: "28ee2134b3276d959ed9ff7864a30154a094276fe3a7cfc2cf7956984d3f769f"
    sha256 cellar: :any, mojave:   "6a32bfdf936cfb7959aac70220b91b1b9b4ef29632419688fb28ee7d0d9bce24"
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
