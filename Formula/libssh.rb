class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.5.tar.xz"
  sha256 "b60e2ff7f367b9eee2b5634d3a63303ddfede0e6a18dfca88c44a8770e7e4234"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "90f69ef4b8bbece825066be8f7eb60ef912119f37b243aff6a7552e140a61227"
    sha256 cellar: :any,                 arm64_monterey: "26a43b44df01e95acd715a58285b86f37d4e619beaad61b5b8e25ea2b8fc27f1"
    sha256 cellar: :any,                 arm64_big_sur:  "93872a55892377fbb96747e16652b2eaf32bb23efce922c5857e5376e549534d"
    sha256 cellar: :any,                 ventura:        "507c82edd04f248d2486ec9ceb906886fecdf1fa87dcaf678e0e0b5f00e14180"
    sha256 cellar: :any,                 monterey:       "9b8d872b9e7d40ebafcf634ecb0071a99b9799603141f67777c4d248533a30c5"
    sha256 cellar: :any,                 big_sur:        "85758a853bc5ab1fb7c5464bc361db49827d0741e7cc0b2966784cd2c63dfa66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c042612efdc39d06a44d5695761feabb3a3f2ff561c1252bd1bf0e7d2251725"
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
