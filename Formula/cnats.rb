class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.6.0.tar.gz"
  sha256 "ce2eb48ac9fa6e89cacb3271f06780a2161c9b7f71dc520e09d4b1b0c4091dd8"

  bottle do
    cellar :any
    sha256 "bcae1cd8aa2f660206b91d2493e4d8d2c62d37f35e4831e15bc4276d542e0d3c" => :sierra
    sha256 "2cb0cff286bad7230ba159f1d44f5b19a8d00078600ebe1110f4070e979fc09b" => :el_capitan
    sha256 "f9d09b229aa310ce11c6e19582b7905fd3e2f59200c4e985050377af9675ed55" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    test_version = shell_output "./test", 0
    assert_equal version, test_version.strip
  end
end
