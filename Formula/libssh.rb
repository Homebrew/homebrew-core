class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.8/libssh-0.8.5.tar.xz"
  sha256 "07d2c431240fc88f6b06bcb36ae267f9afeedce2e32f6c42f8844b205ab5a335"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "6e60a13575ca28cf157d0d81357dd67361389d30b1b850aeeddd3ecc2e6109e2" => :mojave
    sha256 "953e2ab76ee3c9d02eaa11dc8031c8e8f51ff563a3d98bbdcca45e0fc98babac" => :high_sierra
    sha256 "c5b00d8c5552eb98893ebf48ba7267dd7153e46be9f8879c9ee46f320bb642ff" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
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
