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
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "e9373498c8fcf173766124396b2e5e0bca60972a0750a2de17526e6207500bdb"
    sha256 cellar: :any,                 arm64_monterey: "3b486df792e8af162ca9b13d5c8db6ae73134ab8fecb13bdd090bf65e02f9b87"
    sha256 cellar: :any,                 arm64_big_sur:  "33e2c0270faca011e09ebb44c6ec19c56b3a970835f66cee6890a080cf49727f"
    sha256 cellar: :any,                 ventura:        "d4f2d318538dc16bbcbd73f73c41925ae40242a1f28cc8011d369838010d0e7d"
    sha256 cellar: :any,                 monterey:       "d44012d6f9c125137b234fb67dfa1e0b21edf628dfe46b5334f4dade8dbfbf65"
    sha256 cellar: :any,                 big_sur:        "08a808a714ef2d3c7e0d57ee1c1f960b9f85128fd1acdebf06cefc251f37d7c2"
    sha256 cellar: :any,                 catalina:       "9b42e22f7bf7cfb75edb682cff5022313eb0ff6ce4a509f9ec865ffa4cdb28b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d9e0b42e4c0bf7c60855f4eef44c33fa2efe16013fd9171487aa45b5ee73110"
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
