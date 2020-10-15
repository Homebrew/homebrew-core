class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/0.3.0.tar.gz"
  sha256 "b447133039a8fb8df3cc90e22db1453cd67987834d495ac6898ac6a63df7c14b"
  license "MIT"

  bottle do
    cellar :any
    sha256 "f08fb2aefced27d1cc26680e50a1f0df0d87182f923135cd57900a5e3fc0beb8" => :catalina
    sha256 "6a58d68654065e151ca045a81eb0c1e3e786696a84453b6c75aea4b2d449f66e" => :mojave
    sha256 "47d203b377f2702041634aabe030ba786f466afb78b83bbe27a79b3aabcd9d49" => :high_sierra
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
