class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.8.2.tar.gz"
  sha256 "083ee03cf5a413629d56272e88ad3229720c5006c286e8180c9e5b745c10f37d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a85b87a12ef0711c647cbc9d5dd4d8e6340f4382483fdd9bd68d521601e47aed"
    sha256 cellar: :any,                 arm64_ventura:  "0ebd50389b71aafb3eb9634a2d42b75d70c99b62eeb45373e73669bb4ee4ddf5"
    sha256 cellar: :any,                 arm64_monterey: "0aef56d8fe8fdbcd66eca99e7b3c5af119ae4eaf712552106135ae60dd0b97a0"
    sha256 cellar: :any,                 sonoma:         "1c02a3280c07e2f283fb197e75497c91791b6081fc4ca6196773bd0a05e729d1"
    sha256 cellar: :any,                 ventura:        "751e5adda134e3c8fca555bf78b23287e929fe89508f8b9633539393416fc25b"
    sha256 cellar: :any,                 monterey:       "1c929ab71ac2139f0e693eacbdac44145dcac2f1320c4e374b0c43636cfc7d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78aadfaf79af653641fefb5ca63359db3a5e367c56f4b8741d73d00c157b23c8"
  end

  depends_on "cmake" => :build
  depends_on "libevent"
  depends_on "libuv"
  depends_on "openssl@3"
  depends_on "protobuf-c"

  def install
    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBUILD_TESTING=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
