class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.14.0.tar.gz"
  sha256 "5b0df6138763b3fc4e385d58dbb2ee7c7c508a64a413d76a917529e3a9a207ea"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94f528e2e60970064a39baa077b224410a2524e9a2a42492fdf83e16bbee44c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "770374d15fd6f8942b4d22b53c85b61e6253a3abbeff4888309984fc82237962"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3eb84deb64a79bc06abc48ecbfd387cb5e28ad14e1ee0be7639348a0e6ad44f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "67e3d5156d1b65e8b4546b00670963c45777018a0cd6681230dfd19f101debb3"
    sha256 cellar: :any_skip_relocation, ventura:       "b4ee69d66ac1c770db1e744e01f847b0bbcb38e29dc1050880611b7c2eacfc8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fe6581485e6fdf52df28a913643e88dd3bdc89f0f5b69a29f331004903571f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dead3635b08843df33e8b4c34acefdbb589e9b32dad87e8455bd329c6f567e0a"
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
