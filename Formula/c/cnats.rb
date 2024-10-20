class Cnats < Formula
  desc "C client for the NATS messaging system"
  homepage "https://github.com/nats-io/nats.c"
  url "https://github.com/nats-io/nats.c/archive/refs/tags/v3.9.1.tar.gz"
  sha256 "56836bb30a2da93eaa6df0dfa27e796e6be0933b5b3d4d83b5c76d3b80304290"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4048aab049238b3973504ecca6c09eee64097e344a5c233a8ed6c13b89cdde15"
    sha256 cellar: :any,                 arm64_sonoma:  "c9ecd9f8bd0e02961699b17bd1fcdc3dd561ff0e98612b7859560836e539194d"
    sha256 cellar: :any,                 arm64_ventura: "4c8191751fedea59c00d3f4411e501bc4da323ee55f23031a201cf6f8154fee2"
    sha256 cellar: :any,                 sonoma:        "a1c6d852e068568d59be12ce391306d8445fc8e26edd686851791102d2d970ec"
    sha256 cellar: :any,                 ventura:       "f1f0aede9202ebf802dd168400e81234cf68c01d03e955c3f8d6286fd4a9a547"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01d69e37e34e3d3bf1abd1b198069042c424542a65d126256407e4198d1856b7"
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
    (testpath/"test.c").write <<~C
      #include <nats/nats.h>
      #include <stdio.h>
      int main() {
        printf("%s\\n", nats_GetVersion());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lnats", "-o", "test"
    assert_equal version, shell_output("./test").strip
  end
end
