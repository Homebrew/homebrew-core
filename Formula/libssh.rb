class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.9/libssh-0.9.6.tar.xz"
  sha256 "86bcf885bd9b80466fe0e05453c58b877df61afa8ba947a58c356d7f0fab829b"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8487fa5c9e40e22b37862ac114c93e10384f2fd42b810bd290db627663b48af5"
    sha256 cellar: :any,                 arm64_big_sur:  "d6c0de919fb07df2cc4c637eba40c85f2dd19808fae5d7dcabeeb8c9b8477de2"
    sha256 cellar: :any,                 monterey:       "5c1830359324ebcaeca495d51af67b9653de39d00dae55c42a9647b98f85a24c"
    sha256 cellar: :any,                 big_sur:        "cf2110fe6b71f0a5d59a2a4a7bc7badfa5bf53c59bfa2968ac1160519aa7285f"
    sha256 cellar: :any,                 catalina:       "3aff6528d21c6844b4592862628ab197bb5e34e4c506008d24b63afacc116900"
    sha256 cellar: :any,                 mojave:         "c230e01e4990691096acce9e33222f51f1db8fa21b93c8998b82efad871afcf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be12ab5dbd45956b1bd8c26c3c6f5e1a8d7ee20e7e60170a693969f2734309e2"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_STATIC_LIB=ON",
                            "-DWITH_SYMBOL_VERSIONING=OFF",
                            *std_cmake_args
      system "make", "install"
      lib.install "src/libssh.a"
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
    system ENV.cc, "-I#{include}", testpath/"test.c",
           "-L#{lib}", "-lssh", "-o", testpath/"test"
    system "./test"
  end
end
