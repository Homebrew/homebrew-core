class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.15.0.tar.gz"
  sha256 "3983f7cd1247f37fb76a040e6fd684894d44a84cecdcfbdb90559b3216684b5c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "66a64fa3c0a45af280679399c5834168bdb8ad8e663336071a2e6922e3d60026"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b20974a09a4e7778815711de5956f92ceead897455ffa636349b1de26feb9a99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2702ef0480eceb63b78613404c9f77ec281067683a14cb238093a7eaa82a64dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "27fd2fc81eed55057d6b3e4bff5f79987fc8ba4c6122475f1dc79f5aae6d41f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44c8ae89e2ecbc135ba7f6ffb9b5c159671c00e6f5633dc785fdca1b820ea4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6716f67f3792c83e20161edbf20cc11cf8b6d9e7506cba2271b5986fcb5d2b55"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "openssl@3"

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
