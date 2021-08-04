class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/v3.0.0.tar.gz"
  sha256 "2f40c08f6cd01d846ede533c997e64b9d83607cd563e77f4e31e1a5a7e9a69a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "1ddbef391d906fa4834459e078eb8e8d7c666bb720bcd8da731c576b6e641907"
    sha256 cellar: :any,                 big_sur:       "aa4b6edf4b64bdd07170fd094b7239bd53a20751d9b7da5618258f8c802bceb6"
    sha256 cellar: :any,                 catalina:      "1891718b31f29148f28da3b92d560a2557f1f926150d24fe6c832e33dcea8496"
    sha256 cellar: :any,                 mojave:        "67c5d27394d060a5fdff9be70af468cd212900ccaf3dfd27fcf9d3bb5dbe553f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581ff80cdab5d20d3f634ef1bba96ad12fa57b95a344a5d57d81c4fd379e4140"
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
