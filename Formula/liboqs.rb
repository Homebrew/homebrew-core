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
    sha256 cellar: :any,                 arm64_monterey: "5eb35c4cf7d2445589282fa25c8c34cd26aab762c176f7222f625e9e595b1eb5"
    sha256 cellar: :any,                 arm64_big_sur:  "ecb1d30e647211ede634816fd69937fbdbaca6960fd8d4d483ade292aaa72617"
    sha256 cellar: :any,                 monterey:       "2ae8858740cbffa92d27949dd716326e351dd9582542e48541f059a49be55a9d"
    sha256 cellar: :any,                 big_sur:        "2a57edaa4a1efbeeaf51e277b0d7ab7f2cc1ead2bc5d4fb6d93ae492d4c9dd5f"
    sha256 cellar: :any,                 catalina:       "1b1db31d67ba3e3b46b5af0e79da4b45bf6697440ce378c923cb838217f886a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6e90fee4c3a6d0b963c85d858a4a76655e811f9b5698dd7a2a82c9b0209c571"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@1.1"

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
