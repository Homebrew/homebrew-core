class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.9.1.tar.gz"
  sha256 "317e04416604184472a4205e355185741ad4972fed15cc65f5d40c64f96f501c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0f688ad396c8bc407c164d926a33c1771764b0c1c726da9317755f6fe664677"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9833b1339c279e4f8be8c757cea07e911272169e6536727a2e97befb261bad0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b02b83618d8c43316ab9735334f963aafbcd713129a34bf57656e76ca2f7fd2e"
    sha256 cellar: :any_skip_relocation, sonoma:         "9056d026736f0c2b508798967ed3b67c1f70907c13a322ca9910e49038a26d37"
    sha256 cellar: :any_skip_relocation, ventura:        "44097accfb355b009ead16e423f3857bd91a2cab11d7b93982176d28f448088d"
    sha256 cellar: :any_skip_relocation, monterey:       "c899cb5242a90103d76e3dbc58bf380b53c9a01b3e9655c19db8c4ef8a9f495a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc0bf1f5bab87093bdc7241fb6458b8f4be37404b9d363e62c764f9bc9c7fe5"
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
