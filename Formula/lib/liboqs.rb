class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.11.0.tar.gz"
  sha256 "f77b3eff7dcd77c84a7cd4663ef9636c5c870f30fd0a5b432ad72f7b9516b199"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3413f642debe3a66586c5efaf3aa4f3bc1697f5d17aaff31a375e3a24bcb2927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af54fca5fabc83ae77bf2b40de3457997f6e2cf0ce1f21315f8ed8c30561650"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a84bd5c84045fb9291f768921e4c8e97c9535c5470af7b2fbcadea42078a8ce0"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a547a9194e28c4f61ee05ea2ee62da6dc2de31d0eb226f98e04821b36d1aa6b"
    sha256 cellar: :any_skip_relocation, ventura:       "af949e09fbfa8a5e140c7e58a0ca2568ebe5d0c68b5c08840d13f4e897931123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44c1f17f44095ba8bea83d380eebd8c62bf5a56333b0747bc6fe9402cc7d37b4"
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
