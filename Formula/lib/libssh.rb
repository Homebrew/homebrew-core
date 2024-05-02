class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.10/libssh-0.10.6.tar.xz"
  sha256 "1861d498f5b6f1741b6abc73e608478491edcf9c9d4b6630eef6e74596de9dc1"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f46550586eea1bbce8a418c9ce7621909aaad4b96d98004289ea12ccd4593201"
    sha256 cellar: :any,                 arm64_ventura:  "c6cfcd06891daf88f1995cb4165ffd113edfaed6ab3aedc73ffd93ded8f9f1c3"
    sha256 cellar: :any,                 arm64_monterey: "18b4ce639a0259997f4c40ef65168b293dde5ea3b5920a0c6daa1945bf2d955b"
    sha256 cellar: :any,                 sonoma:         "efd1364d0cf49efedae7884db885c77d49e3013e188e902a0aaa4936c9fb1db5"
    sha256 cellar: :any,                 ventura:        "cb08ff2cf90eb31fa277a53591d3c173ab3e16a6f8ba81a7707568e9bf4603bc"
    sha256 cellar: :any,                 monterey:       "aee1684ae587d1f87fa05b1193b0d80c63e0e43b6b531441bdbd9772032d01b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ad6f0fd7ab747f78a8d7df030423e98be8b55f58a6c495686983e2046706706"
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
