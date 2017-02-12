class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.4.4.tar.gz"
  sha256 "fea8c510d6b2ec3df1a9b92b78863780dd0e0fb536070000ed384dc2e05d13a5"

  bottle do
    cellar :any
    sha256 "5519a5385a4459cd68a72eae9732e48ca1bcac95fe6e067f5719c984d749744e" => :sierra
    sha256 "b2b3f93ddb948782066b2504e4f07e3cebe6d95819354394a3113518d87e4ee8" => :el_capitan
    sha256 "77f3d37ac8fffce4a8853f2faadb6cdd7b7e753dd8d038986f45a7695b641a89" => :yosemite
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
      #include <nats.h>
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
