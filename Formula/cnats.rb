class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v2.2.0.tar.gz"
  sha256 "d27caf80bbd560c8a642d9911b285bb3ace6076d2874f9dbb7436ea79292efec"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "b58008b36710c2041b37f6180a7204cb8e46d567c58d1dba51ee3141af0e9be5" => :catalina
    sha256 "846ab124bf300c7103bd39dece489df95e7a8348a214ceebc6613023214b6115" => :mojave
    sha256 "6162657198c7295f28c7aa5bb1b6986eab3835756c0a0b62362a503ff67a6def" => :high_sierra
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
