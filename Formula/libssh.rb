class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.0.tar.xz"
  sha256 "25303c2995e663cd169fdd902bae88106f48242d7e96311d74f812023482c7a5"
  revision 1
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "e1d446593d5686f340c2d3f625a94499c34bcdde92e2931afeb164f22c183c05" => :mojave
    sha256 "577a696d90762ad7b931d5b6fcbaff093bc96f2e720ff7650fa5a3cd1b0ea3b4" => :high_sierra
    sha256 "0693e4930230e6674876a55b2de201b362e85f3931167cfc93f651262848301b" => :sierra
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
