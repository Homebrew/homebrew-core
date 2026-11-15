class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.12/libssh-0.12.2.tar.xz"
  sha256 "49560f677d96e3706a904ac2de1116e25f3680937d51e5c92198fcba4a1c1e9f"
  license "LGPL-2.1-or-later"
  revision 1
  compatibility_version 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "48110039ef444f383b5fab938dffbca01203784eafcf2a05135477cffef15751"
    sha256 cellar: :any, arm64_tahoe:       "37a64163e5cc0960e54354c4159aa32d1f89cab7f2c338d5efe202ecbc1d41a2"
    sha256 cellar: :any, arm64_sequoia:     "69507118740589ed52f4b4328694eeed6a07166527e001f0d43f9c6a86b09d1f"
    sha256 cellar: :any, arm64_linux:       "24f3c7af9ddb26b6bcf3abc4bf37f3139ec9a5c41082f970a3f01007f5d608c0"
    sha256 cellar: :any, x86_64_linux:      "ba38838f03c55465919f13f7dcd307e8195d1705dc066f4548d43776423a5d45"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
