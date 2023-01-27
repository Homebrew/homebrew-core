class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.6.0.tar.gz"
  sha256 "4627ce4cd66224df3b116f84a6085c8085d454c4a21a97b9fc9b60e9f505013b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2957ec06cf57e9403a4f0e66dd38fc00270a1f523ccc6a489f6b9c74cf883c12"
    sha256 cellar: :any,                 arm64_monterey: "a482821e19b8f4361c6a9793a4803463d12e647e96bea94f0a0080e50a3001e1"
    sha256 cellar: :any,                 arm64_big_sur:  "d926ef2351aa53fb393ac2a2cb48cd4c27915f93ddc3d1ae0a8accd823993b1f"
    sha256 cellar: :any,                 ventura:        "2a610b3216a6800086c4f80a380eed31ddc0a2bbf7b8138ee526cb2945e5b8f5"
    sha256 cellar: :any,                 monterey:       "fc1e4265ac55a0811a84cd98ce225960146a7c580d5f9d859a955a9736c40f2d"
    sha256 cellar: :any,                 big_sur:        "f82735102ad5bee2b66caaff59d0a80fb8f9e2f0148686c31ab20cbf1a4aa098"
    sha256 cellar: :any,                 catalina:       "3a780b02e05c05632ce2d7fe1542150ccaecd844d4ff2eb9300def11ab0cbd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f8bb6744c1b36364c7fbed5081159b5445c539679c5dac8b63fefbb831cccc3"
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
