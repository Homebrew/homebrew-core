class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.7.4.tar.gz"
  sha256 "74ca4b380b7c5cb7ae85017d9e50aa23e89f7565f500f40df359d82adb493b93"

  bottle do
    cellar :any
    sha256 "3f4fdfcf6afd14251ef2f434043f7d8040939daba60a9099cc7d9ea753273ed7" => :high_sierra
    sha256 "6bd7954e5f15a75fc8c8e0b152dbf7450c45d35050c91da1e0e471f2d8179ff4" => :sierra
    sha256 "a93f6fbd6a03feb582a5589cd19d5880b5adcc04cab5de2350f40a6a98ba20c8" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libevent" => :optional
  depends_on "libuv" => :optional
  depends_on "openssl"

  def install
    local_cmake_args = ["-DNATS_INSTALL_PREFIX=#{prefix}", "-DBUILD_TESTING=OFF"]
    system "cmake", ".", *local_cmake_args, *std_cmake_args
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
