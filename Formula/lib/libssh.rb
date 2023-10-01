class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.5.tar.xz"
  sha256 "b60e2ff7f367b9eee2b5634d3a63303ddfede0e6a18dfca88c44a8770e7e4234"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bc86fdce19c79441c88b448c745055a953abd3c463939308d2d4879677efba66"
    sha256 cellar: :any,                 arm64_ventura:  "5b5925ae5e0d31dd7b2c508eb1f6a19585a87cb66310d5a658e772666500191d"
    sha256 cellar: :any,                 arm64_monterey: "e8d6d4cf9ef824ef9c47b5dacaf636e608a8ab4cf7af9c8c3431e63ada511564"
    sha256 cellar: :any,                 arm64_big_sur:  "05d9667dd5fefbbea27e2424dd12ed80ee88126f07341a1616ff057d9c204889"
    sha256 cellar: :any,                 sonoma:         "10feea244490f79ffd8e5957347d8ee097b88694085e9bb00577ac4c1c3583bc"
    sha256 cellar: :any,                 ventura:        "d3c33e1e13a0ce529aa1cb61242357f8c2ae90931402e9248f86178aab458bb3"
    sha256 cellar: :any,                 monterey:       "fe5e6d7ee3178a0cbe8b92ca686fab9e8c410359200e359e724a2dcef9a9bfae"
    sha256 cellar: :any,                 big_sur:        "9caf4d93dc7fd37ba7b9acb0288341365fbe5a4d87b3f687e72b1aae29606ef6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0cce35866646c7e66a4752cf4b4cd1c2e7ab7846c49fb5d711ad90bfc3bb03"
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
