class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.10.1.tar.gz"
  sha256 "00ca8aba65cd8c8eac00ddf978f4cac9dd23bb039f357448b60b7e3eed8f02da"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a3d13a09430ca4d5b43704ab70d357476b7b1849822cec398158bbd2bbb9b8c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0971baa26c5113916331dcfa4ecca341e435853a51421a183ef2dd4ad7f5315"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "918b8001f0ab62414f7ec83d49a76e46a9b7324b2f3c13dc9872a67505b01c36"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d2eaa8e9860d440e1c3eb2bbc12b592c0e9f2304e5cd839df866606738da5f0"
    sha256 cellar: :any_skip_relocation, ventura:        "5a67eb85c129fe8a8ac240e80acae5f1606f4cfede2de5fd828910389add3562"
    sha256 cellar: :any_skip_relocation, monterey:       "f4f3f71cfb1845d1dbc2583dd8522ccf01055f67e5135213a929f9549df57010"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c6800a9bce9c919840ef2133d8e7acfc36bc9d1bc50d89da4d4116eba02a6dd"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    args = %W[
      -DOQS_USE_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "test.c",
                  "-I#{Formula["openssl@3"].include}", "-I#{include}",
                  "-L#{Formula["openssl@3"].lib}", "-L#{lib}",
                  "-loqs", "-lssl", "-lcrypto", "-o", "test"
    assert_match "operations completed", shell_output("./test")
  end
end
