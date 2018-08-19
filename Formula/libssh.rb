class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.8/libssh-0.8.1.tar.xz"
  sha256 "d17f1267b4a5e46c0fbe66d39a3e702b8cefe788928f2eb6e339a18bb00b1924"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "735a1ab76bda6801ee0907737939903f923ab469af509303bef63df7ae264e4b" => :high_sierra
    sha256 "ccabcfaadcf5a25ea951f8eaec4310caa83a2bd76fd90589e405d64d3eb4d918" => :sierra
    sha256 "76c42f9c092b0249dcfdbd1ddd0be57eb73a099ee5c6d9a213a7ff7cdc6f4393" => :el_capitan
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
