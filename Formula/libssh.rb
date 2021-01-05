class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.5.tar.xz"
  sha256 "acffef2da98e761fc1fd9c4fddde0f3af60ab44c4f5af05cd1b2d60a3fa08718"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "fe61461e16b891d6e8f52ee03492f0f84de879f80d51d36c86dbfac366608495" => :big_sur
    sha256 "8c2e8ae24564323b6e99068492a7bc029986e9f757e676234a516f373ff1ff19" => :arm64_big_sur
    sha256 "e990bf70a0eea0f91970ab4e8ffe414cfad55fcba459a7a08d704a3b26200cd3" => :catalina
    sha256 "9f7af086488d919155cd0c72a66a914b27d278a74d6231d77b07bbafff25ec33" => :mojave
    sha256 "f6615bdb785f88763212f4b0d393dc302237353abcf299d4d6151531ecbf13f4" => :high_sierra
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
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lssh",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
