class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.1.tar.xz"
  sha256 "d3941af0a2d78d5d82ed7a36988e9133994312f035b9659a6e43f8db3968784c"
  license "LGPL-2.1-or-later"
  compatibility_version 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cb24e5d3b07b6f75a55e0298dcc67af2f98f7a9adc63326dc140d170df39791e"
    sha256 cellar: :any, arm64_sequoia: "3a404b9536be6786d60b8f83d554d91e8de6b9c580e7d90aaf3c92c04bc36c5c"
    sha256 cellar: :any, arm64_sonoma:  "6d110b8e5d6c7e71716c3c2eb8adc354346f74a885fb1835ae942148d1c91c15"
    sha256 cellar: :any, sonoma:        "8a27181841eadfa3ea535e65d15d809d3fba2995b881a5a0f3b5acade57df769"
    sha256 cellar: :any, arm64_linux:   "eef4daccd8f16231ffc879516afb6667f0a91f50ce985f52a2bb93e1b3426634"
    sha256 cellar: :any, x86_64_linux:  "52ecaf48a35ac5ba1af3c52368f9b682e3657647d0d4d774168fb994de37eb5d"
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
