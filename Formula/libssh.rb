class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.4.tar.xz"
  sha256 "07392c54ab61476288d1c1f0a7c557b50211797ad00c34c3af2bbc4dbc4bd97d"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "070835503169e43125a6c78d21229e8b1489c0ec37d2899e3658784513434789"
    sha256 cellar: :any,                 arm64_monterey: "3932e63ecd8236e305a43d1aa27c98957b8c513171873d21fd9858671c1b4a5d"
    sha256 cellar: :any,                 arm64_big_sur:  "3b2886c28cb74cc6eec70cc7fe0225ec55567848df8cf5b97cd2226b56a91675"
    sha256 cellar: :any,                 ventura:        "977c22fa0c47b658e37b719914f8896e7f32057ff10e2151ed25606d9af6149b"
    sha256 cellar: :any,                 monterey:       "4c965d61eef0b2ce050e191f399f7f84d9300035d444af06b72b7401e0927e20"
    sha256 cellar: :any,                 big_sur:        "8338dc10bac32e5c6c3a5e4004f6067c414ff179658271e7c886385efeb8ef43"
    sha256 cellar: :any,                 catalina:       "4e02e90e4e3691c4ccfdd67ffc66041b15d60d8bf5b75373f84dcf49d28c93eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000115cbf2dac1a926830428ff9685bfca24e7a745017e0e6f50dcc5c9f5a15a"
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
