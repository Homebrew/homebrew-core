class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.8/libssh-0.8.4.tar.xz"
  sha256 "6bb07713021a8586ba2120b2c36c468dc9ac8096d043f9b1726639aa4275b81b"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    cellar :any
    sha256 "dba405fa9a741d7dac9d46d952d37b4afb003be9333860da8ebc5e6066b60ba0" => :mojave
    sha256 "d3a2bfb23a4bea4612f1cfb21134cee68095e04e985c4b539d6501c65a5e3f6f" => :high_sierra
    sha256 "928fb81a69527bf80cc4eb423d7d9474e3e84883376307d554854e7539541b25" => :sierra
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
