class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.2.tar.xz"
  sha256 "15b83d7b74c8c67f758fb32faf1d9a35d5f8f50db523276a419e9876530f098a"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d1618b2d05e9b606fb966c229be6c02de09451661920fda23771a14090668bd"
    sha256 cellar: :any,                 arm64_big_sur:  "6c06a36bed70ddb7db05a30ee26925e8630d8ac0b435ba71eacc3061ac34c639"
    sha256 cellar: :any,                 monterey:       "281721cc472ca1ceabe2f6b609e034f883285619ab417aafc17694ab88992f3f"
    sha256 cellar: :any,                 big_sur:        "c2420304f48fa3aed966814687f7eb3fae7528e9de472a51fe4396847ce1aa16"
    sha256 cellar: :any,                 catalina:       "9baa4a1911c68514613f8e53e1e2c55cf21cad869e293537369faab78777e046"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82d3cb6b7ec1cc5ed0cc71dae3adbbbf1c3ed140c853c70cf5f1ee78e6556d05"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
      lib.install "src/libssh.a"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libssh/libssh.h>
      #include <stdlib.h>
      int main()
      {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lssh", "-o", testpath/"test"
    system "./test"
  end
end
