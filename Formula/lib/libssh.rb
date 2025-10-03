class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.11/libssh-0.11.3.tar.xz"
  sha256 "7d8a1361bb094ec3f511964e78a5a4dba689b5986e112afabe4f4d0d6c6125c3"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e91e604beda45807e4e95bcc49aa19370e7060d27589e03ef76b4669965bcf79"
    sha256 cellar: :any,                 arm64_sequoia: "ed8b3a5fc472d34a7dcc545125ad1b46018cb6a285f0493c983ed0057137dc1c"
    sha256 cellar: :any,                 arm64_sonoma:  "e138277845774eced73507b57d2e88ce083563e5c4422547ca3ee40828f4fbcd"
    sha256 cellar: :any,                 arm64_ventura: "d964e62f422c90ce3993d41adc3f101196c24e3330c6e03e5c5a06bb42dfbd85"
    sha256 cellar: :any,                 sonoma:        "ab10e4e2fcd6ce97b7d7c7dfbaea0067fdd104d2a48fca3c879bfcf3cf43a60f"
    sha256 cellar: :any,                 ventura:       "4fec93f5cc2f344a18f91ec3ac76a9db6243acc3a4188772a9d7c2df579e5e95"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a1d91932020c21898b7bd78cf3175e86af36f83bac9bb7ca936a41a7cac0285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3ea38523d0d8393df13be75c57f251ef7af84777edb9a643d302fedad89d39df"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

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
