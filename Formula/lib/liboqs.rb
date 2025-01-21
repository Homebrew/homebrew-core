class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.12.0.tar.gz"
  sha256 "df999915204eb1eba311d89e83d1edd3a514d5a07374745d6a9e5b2dd0d59c08"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5933c36ee1ae57715e130981f2ce1224686786b2e7f0c7016ec204057b61b79b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eaf31e61184b48db56d72b601b469229855634e7f558461767c1322ef5d844c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6164c5d38336d5c42b6aaa13f684e9e1f038711e664dbf97cfef836486d77884"
    sha256 cellar: :any_skip_relocation, sonoma:        "096ad57418c538b5e9f07d3ce1345ce710d53fcb189d7b21e103f1787048f984"
    sha256 cellar: :any_skip_relocation, ventura:       "d85399bccbdd4e7bcb10a4cee742151912c02fc4f02f6a34a5e040eb843c5498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f8a5388084f775a73d08949df3800d9d16b07b12702c084586b079cc1664b23"
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
