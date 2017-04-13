class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/218/libssh-0.7.5.tar.xz"
  sha256 "54e86dd5dc20e5367e58f3caab337ce37675f863f80df85b6b1614966a337095"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "09fb5a3a3f246e4962d3a966d9f0b8bdadcba7418585c528ec55cb72e032152d" => :sierra
    sha256 "43cc3485c0f8844a5d5426e14b60074d6b6d0a42997bf5becd4a037e7e944db0" => :el_capitan
    sha256 "8bce24f3728efa8965f116d095487789e3482e7a6c29586b7bc9a79ec6437292" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"

  def install
    mkdir "build" do
      system "cmake", "..", "-DWITH_STATIC_LIB=ON", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
