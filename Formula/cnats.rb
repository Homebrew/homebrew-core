class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.5.0.tar.gz"
  sha256 "2a3fcba547a36c82ad25b2e9ff18edf5d761024c242b1634b208af48eb59f52e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1ca08203f353fd313afa34ee69f5f91c980779bc3e8842ec55932c933dbc8ac6"
    sha256 cellar: :any, big_sur:       "c4b31706b10c63793156ec7174fe88665d1d52a5cf40036b3790b6c5e4c8c36d"
    sha256 cellar: :any, catalina:      "f47660174a6996c9dc11459dba19b25b6085b2025ec71a2534dad5f839785a82"
    sha256 cellar: :any, mojave:        "7f240dd1c2df37557eec9cffff09d03b696eab091d8bd15c0328c7ae3b5afe09"
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
