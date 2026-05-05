class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.0.tar.xz"
  sha256 "1a6af424d8327e5eedef4e5fe7f5b924226dd617ac9f3de80f217d82a36a7121"
  license "LGPL-2.1-or-later"
  revision 2
  compatibility_version 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9b0b1a1f4a68362bf19141abe67a5bb5c71148e5c08eb509a8e1bcfa96fa460b"
    sha256 cellar: :any,                 arm64_sequoia: "e29f3362ab6628b3aa12ba06e9f3f5debdfc8cf033a82dd3418cd329b2bc98e0"
    sha256 cellar: :any,                 arm64_sonoma:  "0ec26854f084440526615ea2b003f3999af0e1243d74fcdebcc5134668eae800"
    sha256 cellar: :any,                 sonoma:        "dce1e66b5f37ee72aeac25e5053622c51d49a7d821d464515c8289e69a9d7018"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f926d3875307086b47c8c125537ccf4654c9caf6d7a820a56b078860ab1f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c16c378b54db654c4fb85a474235008e1453da95b10e2f157a94637d01d5bef"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    args = %w[
      -DBUILD_STATIC_LIB=ON
      -DWITH_SYMBOL_VERSIONING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libssh.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh/libssh.h>
      #include <stdlib.h>

      int main() {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lssh"
    system "./test"
  end
end
