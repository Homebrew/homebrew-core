class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.0.tar.xz"
  sha256 "25303c2995e663cd169fdd902bae88106f48242d7e96311d74f812023482c7a5"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "68027b65dae117340cbaa3b72f09850322b16a11609b4e334d0b2c9d6f4a64c3" => :mojave
    sha256 "c63546c5f5381f26d91e71ffb0c40f9b312534af3fc4548e1c170650be79c0e4" => :high_sierra
    sha256 "8b812b8b13bfee80ab5efbe5de89962138f7d40fa692cde93a3b22b834f34066" => :sierra
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
