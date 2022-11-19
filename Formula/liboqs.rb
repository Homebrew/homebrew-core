class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.7.2.tar.gz"
  sha256 "8432209a3dc7d96af03460fc161676c89e14fca5aaa588a272eb43992b53de76"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "54ce69904ab51780b9990b7a6f42c463c902464303da2a5a30894147bbdfef10"
    sha256 cellar: :any,                 arm64_monterey: "229cc26dc8f4ebd3f178ae31e40c1627a5e3b5dfd30d15c440e26dd8b3e289e3"
    sha256 cellar: :any,                 arm64_big_sur:  "4e80fd4cfee7fd4cdaf4560befaddb01f02886123409036daeea2ab73ebf253a"
    sha256 cellar: :any,                 monterey:       "41ac926d23bb6c05e82d4a30072a3e7b9f5bd573110b06fa931f032aa81cb1b2"
    sha256 cellar: :any,                 big_sur:        "98ffdb22f4e52fb8ba6eba99834d3b9c729d2030f99d8691b059cb307ea60390"
    sha256 cellar: :any,                 catalina:       "a4ab1395ce808507b8af6316ceb58d1a081c172e21bd24d107e98829620f5b86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d3d91f8b15c231eb1f95bfb886761304429f210f30bfcfdbe45ac6541c4f01"
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
