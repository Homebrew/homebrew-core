class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.0.tar.xz"
  sha256 "1a6af424d8327e5eedef4e5fe7f5b924226dd617ac9f3de80f217d82a36a7121"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfbd08103692e8ffbb2cf33596a8b1f40dea83dba35621732994c921dc50e338"
    sha256 cellar: :any,                 arm64_sequoia: "90d7d2f53f98da8a7f02c13a661575370941603f1409f7e4a3667d7360c4c58a"
    sha256 cellar: :any,                 arm64_sonoma:  "28078e9854ab58dbedd7f8d9391cb28869932c73907c54a9c00612af2bc689eb"
    sha256 cellar: :any,                 sonoma:        "95737ba81393b810ef51b6e88e1422067987edc9843dc4263442d3e93b05104d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488dbc9708070ad0586823f1a17e4a53605205be5a39948aba60af8dacbc6285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c7bd3b80655c34b25165fef797c3e1bb9b223423d58ba04353d2b6239ea1189"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
