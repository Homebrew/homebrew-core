class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.1.tar.xz"
  sha256 "33249bb616bb696e184cf930ea5d14239b65bb999c0815589efc35e5ed895787"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "74fdde520ec3ade933cf816bcdf69436df7367e773146e17c306a63a4621aa29" => :catalina
    sha256 "d28960f6aa95acab2c1ee8bef2d6d1066ee6cbae447cee5ccc53b68d6773c932" => :mojave
    sha256 "fde8aad0cf4d32bc438ca2f64b378fa318641b54d94e6397587e697cfff6add5" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

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
