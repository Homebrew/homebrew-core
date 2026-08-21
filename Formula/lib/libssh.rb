class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.2.tar.xz"
  sha256 "49560f677d96e3706a904ac2de1116e25f3680937d51e5c92198fcba4a1c1e9f"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d7992b5269b93e53695ab3e52037eb454e846e46627a32d60df416a71fb71ea"
    sha256 cellar: :any, arm64_sequoia: "6e339868a129237e8fdeadd4934784ad1a877dde2726551610412553e7e5e6aa"
    sha256 cellar: :any, arm64_sonoma:  "da189379e290d2096857aebd46b8cdb62236d9f4abc3edb4cfc77f6258b0d91a"
    sha256 cellar: :any, sonoma:        "8307e0351668b49f47dbbc48ddc278cf7a305162020bcd0f2b88809ccc625b09"
    sha256 cellar: :any, arm64_linux:   "4dba912d87dc73996b5c8b883dd82ffa3b147c792ef509db6fcbc904c9b11d4b"
    sha256 cellar: :any, x86_64_linux:  "272e64fd608b6c6ce999810bb72e034700f4d785ad852692f6c8dccfaba9ba6d"
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
