class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.0.tar.xz"
  sha256 "25303c2995e663cd169fdd902bae88106f48242d7e96311d74f812023482c7a5"
  revision 1
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "de311a90dbad3fddc951232d0f51ff891c58a76b33f45b163a47bb5dda07af1a" => :mojave
    sha256 "5392c240d04b86930a53a77e831fea8141b74980b4511da9eced14821a2ea311" => :high_sierra
    sha256 "f04560efcabc429dbcb8b3606681e094e8ca33aba028b79c5ff79e13ae18763a" => :sierra
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
