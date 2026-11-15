class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.16.0.tar.gz"
  sha256 "162d5b510518ee5f285f82fa1f16402a885176e818bf1b1a4c3c91c9a2f01eae"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "49219c29dabe554d5a94683c09188a52f0a809875bdd88e70342abbc10690d7f"
    sha256 cellar: :any, arm64_tahoe:       "d1bafc1d1aa7d09b2b4c5efb2d4713327fc3100cfd9bf149851ac7d3fe567546"
    sha256 cellar: :any, arm64_sequoia:     "eabb4df936ed371458d18485e9b59bcd315ad59e06d38b90a0a859e522cb9491"
    sha256 cellar: :any, arm64_linux:       "6e381ca66850b6eec6638f7f9c2b55ed3786b00a8164eecc3940e01ca1ec5dfa"
    sha256 cellar: :any, x86_64_linux:      "85a55828104442d9fb8f162d3d94f2e1e04e7c723b640abcd2d18f58a3bb68ce"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@4"

  deny_network_access!

  def openssl = "openssl@4"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DOQS_USE_OPENSSL=ON
      -DOPENSSL_ROOT_DIR=#{formula_opt_prefix(openssl)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests"
  end

  test do
    cp pkgshare/"tests/example_kem.c", "test.c"
    system ENV.cc, "test.c",
                  "-I#{formula_opt_include(openssl)}", "-I#{include}",
                  "-L#{formula_opt_lib(openssl)}", "-L#{lib}",
                  "-loqs", "-lssl", "-lcrypto", "-o", "test"
    assert_match "operations completed", shell_output("./test")
  end
end
