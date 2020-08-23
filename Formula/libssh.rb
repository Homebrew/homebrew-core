class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.4.tar.xz"
  sha256 "150897a569852ac05aac831dc417a7ba8e610c86ca2e0154a99c6ade2486226b"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "80a7241688554d68ba4dfdcc04a69711ed02dde72f496603565ab9f0c5198df3" => :catalina
    sha256 "25fbc3fa80454fb8cc8733d26dd811840020cb301e2515a45866325520905039" => :mojave
    sha256 "afc9749026ce1c566415227e36f6e528e90d79e11a650718ed9d3a51bb3027f0" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

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
