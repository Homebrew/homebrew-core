class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/210/libssh-0.7.4.tar.xz"
  sha256 "39e1bec3b3cb452af3b8fd7f59c12c5ef5b9ed64f057c7eb0d1a5cac67ba6c0d"
  head "git://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "7353d11d1799080dbc4dceded7905f252479f590243f1d1a98b9c270dbe279de" => :sierra
    sha256 "4e3416bd5087d748d049b00f857342db5e0d30cd4379d6c9257fe96f351d75ac" => :el_capitan
    sha256 "3bb54bb7b07cabfdfbc44d17bda3254327287cae4bc47ed3c170ce85eca1f8c2" => :yosemite
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
