class Libssh < Formula
  desc "C library SSHv1/SSHv2 client and server protocols"
  homepage "https://www.libssh.org/"
  url "https://www.libssh.org/files/0.11/libssh-0.11.1.tar.xz"
  sha256 "14b7dcc72e91e08151c58b981a7b570ab2663f630e7d2837645d5a9c612c1b79"
  license "LGPL-2.1-or-later"
  head "https://git.libssh.org/projects/libssh.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ef7a07e8b469c92123e7b81ee8356820e1e6866d8e05b278cdd544d1c7d4bf97"
    sha256 cellar: :any,                 arm64_sonoma:   "0a6184ee3bcd7d1ef5deb30a1534d04a90ba4f6070eddd5a05fe75b9acc20ea1"
    sha256 cellar: :any,                 arm64_ventura:  "9de46491d931e959172d96481de25cae970c55d2b5212a8fae8224208940c42d"
    sha256 cellar: :any,                 arm64_monterey: "a9f3409bf9da4337393b2594157adf571c6c3fd5d421de079fb1bcf544a1a16d"
    sha256 cellar: :any,                 sonoma:         "371ed72cfece039f5abec57b2c2f4a0c2782a0df85a9eab622df75ebcd28c63e"
    sha256 cellar: :any,                 ventura:        "09014e85c296ec5452ea0958b8169b5d0eee8534b6f4b7f1bdc6055dfb35607f"
    sha256 cellar: :any,                 monterey:       "8efb6ef891e6c9d2e9f7f1086d91663bcc54a4e6dec3a4c212f993ffc4a0abca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b711f58f15aad1d605cbecba2cc82d3375fdc422b9938c890f5a57c35918ed3"
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
    (testpath/"test.c").write <<~EOS
      #include <libssh/libssh.h>
      #include <stdlib.h>

      int main() {
        ssh_session my_ssh_session = ssh_new();
        if (my_ssh_session == NULL)
          exit(-1);
        ssh_free(my_ssh_session);
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lssh"
    system "./test"
  end
end
