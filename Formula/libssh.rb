class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://red.libssh.org/attachments/download/218/libssh-0.7.5.tar.xz"
  sha256 "54e86dd5dc20e5367e58f3caab337ce37675f863f80df85b6b1614966a337095"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "287869ae7536b9a6fc3ff22fe130e6e0fb5c7cb41dcf711fe3a52539263b821a" => :high_sierra
    sha256 "5b8593c4a2ec1d79736a8e37ed840c41801e9b9acba0f08e52eef8f64fb30558" => :sierra
    sha256 "9c752b4da40e1f978b808a927f3efb0ac06f2e48328c3e2a544b541c6f9131ee" => :el_capitan
    sha256 "fb6872e410e6ab010d1ec7b2a51cb55075c32745676ef462a276cca87ad18a62" => :yosemite
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
