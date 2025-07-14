class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.11/libssh-0.11.2.tar.xz"
  sha256 "69529fc18f5b601f0baf0e5a4501a2bc26df5e2f116f5f8f07f19fafaa6d04e7"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8f9af47712038dc23da1618d4a90e73e39f167bbc971a77b1c838445096aff63"
    sha256 cellar: :any,                 arm64_sonoma:  "910c57d5b9f6e9a1443cb99cc3dcafe528cca2b4fbf942bce68c10c681f517cc"
    sha256 cellar: :any,                 arm64_ventura: "484200a3186f4b08dbe57d764fa3184cb91b32301684b5444b4a49a2baad2943"
    sha256 cellar: :any,                 sonoma:        "e675197970ebf2eaaf0a09ba417323c5be36c15e6efb758f96d8e87910541e5d"
    sha256 cellar: :any,                 ventura:       "2ee01705846bdf272265617a71108c7c502c3a8437b88b5506505a8e3e146c33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba6ea1df0b7b1cb1ce54cce7a17fc246eae08d39c0dfbb1e3eba1d9dc30a4db9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63ec535bbe923fd72ba0ec0c17c6b8244f21a20320f03c8f79b319fa3b7016d6"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    args = %w[
      -DBUILD_STATIC_LIB=ON
      -DWITH_SYMBOL_VERSIONING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install "build/src/libssh.a"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <libssh/libssh.h>
      #include <stdlib.h>

      int main() {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lssh"
    system "./test"
  end
end
