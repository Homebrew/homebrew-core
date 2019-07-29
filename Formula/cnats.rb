class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.8.0.tar.gz"
  sha256 "aea6b1266ff7f169caeaa0f2b5efaf6081256a9ec17c38de417fdde36dddc4fd"

  bottle do
    cellar :any
    sha256 "32c955ee1bc0a09b634422a54b210091155dd5a9c3328dcc0279f5c719fc3c75" => :mojave
    sha256 "55a68b75889ad00cfdceeefc319b9fcf1f48d27becc17ee94f2c2bcfe08324f1" => :high_sierra
    sha256 "ca720f973960eab911465daf560eed2bc7e65ab40d2f106b23fe46060b82c3cc" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl"

  def install
    system "cmake", ".", "-DNATS_INSTALL_PREFIX=#{prefix}",
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
