class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/cnats"
  url "https://github.com/nats-io/cnats/archive/v1.7.6.tar.gz"
  sha256 "9155102243c6c7a3e9a6b37b259f7587bcfbad5f9521fbe466be58a4517df769"

  bottle do
    cellar :any
    sha256 "3e34fac272cec320dc7256515a39ad165ea88cd0f6e8423aab95df1d0ec2f423" => :mojave
    sha256 "93634acc0e5dc64ffcd7e664bd61d58b138293f2462aca247e85a29e1f0c9154" => :high_sierra
    sha256 "b7b780159a6dd26e6b998b5fc602b62781e1c9b9aa0aaa58872c2402e82e1805" => :sierra
    sha256 "c0bbd1825975f69b7ed172c3ad428a36494611ea56cbdadd9b6288cc26154929" => :el_capitan
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
