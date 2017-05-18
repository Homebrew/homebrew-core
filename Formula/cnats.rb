class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.6.0.tar.gz"
  sha256 "ce2eb48ac9fa6e89cacb3271f06780a2161c9b7f71dc520e09d4b1b0c4091dd8"

  bottle do
    cellar :any
    sha256 "c5f6782a97fbc34c5eab1e691149584106f3cf431d3ffb6dc89a872b02ae8c4d" => :sierra
    sha256 "0005f2119171c8eec7ba86d361558eebf4eecc45fc88f1ae21c8fb635e342ac2" => :el_capitan
    sha256 "fa803d487a0d39706aff123c18d102df195b07149f71187549c808755aea5cd5" => :yosemite
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
