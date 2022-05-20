class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "16e700d912034faefb235a955bd920cfe4d449a260d0371b9694d722eb617ae1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5114ae8c2a739751106854fefdb5b42c1947e1cd71ae240ea096d2da85aedad8"
    sha256 cellar: :any,                 arm64_big_sur:  "dcc8ac411010bbb84a4181ca3043f0effffd328cf938043fab280171f4047588"
    sha256 cellar: :any,                 monterey:       "073db563f8cda3917318e4e470c2a37d453985ee5a4a59818390e6432cea7f21"
    sha256 cellar: :any,                 big_sur:        "cce04a33a7be13d9096f6b3dd4c15d72f02592fa7b4771db66251597163f8053"
    sha256 cellar: :any,                 catalina:       "784d10aef6aae06088e48f1d49c8152174e9a5bcf32a3e35fd005b12a42c3ef1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa781c9c91abb8d291476e838302704874d5db1cf8e105efa7049c791d38501f"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "protobuf-c"

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX=#{prefix}",
                         "-DBUILD_TESTING=OFF", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
