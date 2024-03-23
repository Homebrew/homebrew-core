class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.10.0.tar.gz"
  sha256 "2b7b4436be9825dd0adaf000ee4f322f06551e638a8a9c8d54eda48ed40e40a9"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22c507f7454e4c48d4d95e10e47519d3ec013271a5d6efe699ff8c3a9a31d6ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4adce4fe5fdf96a1976c6147aac9240f83ad52aadf87055c418e41906e283bbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99f8d2cb9fa1b191aa7709a77f62a75d7e9e63570993e76a8c1f3abc3422cabf"
    sha256 cellar: :any_skip_relocation, sonoma:         "005f02532db38347d34dcd71abd2d173836a34b670f187d21dedf7b48ea5d30f"
    sha256 cellar: :any_skip_relocation, ventura:        "095c9b253d0707b216a0f861bf027fef2b5c5aff3771cf14dd01555cac41fa75"
    sha256 cellar: :any_skip_relocation, monterey:       "791228999d340ed9bea1b7a46c596e7ac84662fc5a0e0ab8802bb40cae37c477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "129b04dfad422a26f250ef03cab2ef36f80dbda84a6ed835954bf3dc2b523d56"
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
