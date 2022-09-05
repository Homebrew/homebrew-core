class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.3.tar.xz"
  sha256 "6e889dbe4f3eecd13a452ca868ec85525ab9c39d778519a9c141b83da738c8aa"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c2380956d61bf6828e25252ca7e3a48369d38009ab1d64c763be0353333bb71"
    sha256 cellar: :any,                 arm64_big_sur:  "6aa3355f54c60adbca9c907847d9f5b4fbc9ca159f37134a04654bf000d6faa5"
    sha256 cellar: :any,                 monterey:       "3128ca5096b1a1fabc6a6dbfeaa937ba72fe5bc41cfe94cb07c597641280a305"
    sha256 cellar: :any,                 big_sur:        "4a0fc0bad5938696f8d6aca28461c65ec3f3025129cceb499913ff1318ea7470"
    sha256 cellar: :any,                 catalina:       "6d20e7f1ad8050e3190240b769512c74f140e3cb79ad4d36b83a467434bb2aca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46af6cb9b5476cac086abd815aa24d6b5404678a053abc3348346501b1f1854f"
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
