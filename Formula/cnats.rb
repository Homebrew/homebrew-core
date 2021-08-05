class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.0.0.tar.gz"
  sha256 "2f40c08f6cd01d846ede533c997e64b9d83607cd563e77f4e31e1a5a7e9a69a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "203a8acc266ab99a4215401fe8661ac4a10afd52588a0d9a623ddf0259babf88"
    sha256 cellar: :any,                 big_sur:       "fccb529efbab63b3b7f93d4a561a924a3ac62748e6a1b2622b7f4b47d30935c6"
    sha256 cellar: :any,                 catalina:      "5b4f43ce3b3ec45d4886d5e66ed99df4c0878421628140eae4c140c0d4d65a2e"
    sha256 cellar: :any,                 mojave:        "0cde1cbe2fb54e18964a7ccfe48ada464044496a32fc75cfa4a1a01611a759a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcc6cec4d5dfc24ebead5dd87ad140cd20492dd74d10d9876a44844b3b1aaa6a"
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
