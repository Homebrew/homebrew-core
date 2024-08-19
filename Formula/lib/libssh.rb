class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.11/libssh-0.11.0.tar.xz"
  sha256 "860e814579e7606f3fc3db98c5807bef2ab60f793ec871d81bcd23acdcdd3e91"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5f6829574f6e7a104a64694c67f26afa244503fb96904451f4910cde66a26f3"
    sha256 cellar: :any,                 arm64_ventura:  "47afd30ec9c6e3e159463ae9ddb271cf76027140b9aa44a5e9c177016c873d46"
    sha256 cellar: :any,                 arm64_monterey: "f5623b56b23fd04145e434f29a7ece5b7b2fb963906aa831a581c95b69ad9bdb"
    sha256 cellar: :any,                 sonoma:         "36e4e1803b851b4eb7ea35f31f0f16630ce3e22b0c85895c97fa31d70e6cf699"
    sha256 cellar: :any,                 ventura:        "20879184fe2e6dace8942c63ac55f7ca9504c267478d04e62d0c99bbe2e713af"
    sha256 cellar: :any,                 monterey:       "6dc7bedf5ae38f19aa8a133935d5f39b5ae958851bbbb00a5814fa83ea34ca25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afaaa892af36a5e0b1e574c504ab6ad89cd34e78db7368a280d441af68a6cd53"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

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
