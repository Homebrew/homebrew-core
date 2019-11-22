class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.2.tar.xz"
  sha256 "1970a8991374fc8cbdcb7fcc3683fe8f8824aa37d575f38cfb75fe0fe50fd9ad"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "63c7979df8f85f241141ac083d8725fd663623e5c2393bf9cb499fabaf6c8307" => :catalina
    sha256 "9d633112591ca3abfbd59815ebb7736bedff6c7038ae083df88b898f9d4b000e" => :mojave
    sha256 "af8609b52c9254f0eb422846e51b26dab41ee1f9921a3ac96af7ca83eacc8f7a" => :high_sierra
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
