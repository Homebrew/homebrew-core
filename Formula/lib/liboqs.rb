class Liboqs < Formula
  desc "Library for quantum-safe cryptography"
  homepage "https://openquantumsafe.org/"
  url "https://github.com/open-quantum-safe/liboqs/archive/refs/tags/0.13.0.tar.gz"
  sha256 "789e9b56bcb6b582467ccaf5cdb5ab85236b0c1007d30c606798fa8905152887"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d744db00855ed3160fbde340abfcab59737229e129bafd08935057c0a49813a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a92276be04c12a3dff2be837e1debd1f9c8be9e5e4e0c084f72afb70cd6e083"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7da043db1c2204f9f3a32504dbe35e69ad5c377137244a2df5ef4b6b08cb73b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d34c219fa4023fc0c6182cd4877be12d8b14c55570bfc54a174ed064c382ef2f"
    sha256 cellar: :any_skip_relocation, ventura:       "6de8bf61014b4fba88ce3a44665ddc6d673f88a2a1229d598f75636437d2b0ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21421d5b937bfb972d9239c9265ca2efc484692da94d663694164986b34d51de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2baf046ee42ff6c9aec54dd599c97bc8b6602a86f29c8f5292de05ac41268715"
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
