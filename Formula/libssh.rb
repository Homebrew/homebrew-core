class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.4.tar.xz"
  sha256 "07392c54ab61476288d1c1f0a7c557b50211797ad00c34c3af2bbc4dbc4bd97d"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d267476dae9acc87a0ce409bddc289719f05f8c36c13ff2e0e89111552176107"
    sha256 cellar: :any,                 arm64_big_sur:  "c5a7c1b78b7cd551910d0252061336701fb5f8a9e5e298dbc5213cf469e98300"
    sha256 cellar: :any,                 monterey:       "bb2b352265ad303a481e3a209c9ac94a9d77e2e0bb338c272a0efcaf086328d0"
    sha256 cellar: :any,                 big_sur:        "c200671622e618c3c74973089b6df4d45c3df02e410c9d69136ce5d2ceb56f46"
    sha256 cellar: :any,                 catalina:       "d367597bfaa35eb12b5f955ed0b18604e72b7359ef516537f2518f2357c769ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "140ff80136378bf2ee57b3d92ff93eab794f2bf02e90450147323d51fd699741"
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
