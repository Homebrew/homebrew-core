class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.39.0/qpid-proton-0.39.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.39.0/qpid-proton-0.39.0.tar.gz"
  sha256 "41f3a8d910ba96dda79f405a35e943465d9869cd075346650c7d6c0dc33a6459"
  license "Apache-2.0"
  revision 1
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "be3d9e43662e0962b77edb845ec4edb481aa1f20beaac92b11de19bb581f45f2"
    sha256 cellar: :any,                 arm64_sonoma:   "ae7cde3f2c19dd6b34eb1d890e9eb70f6b5afa55ed80cd0ba70392781d54bda0"
    sha256 cellar: :any,                 arm64_ventura:  "bc2035cdab5e0195df720092370e11a02e8db25476a374cfd9a90bd5c6243149"
    sha256 cellar: :any,                 arm64_monterey: "b5e3877a2bae6bfff13261522c578baffcf130864319f2adfc5aee83c523a825"
    sha256 cellar: :any,                 arm64_big_sur:  "b855d44527bca4b1ff1923c11a65d31f4309b268b9d8fe8f7d00d8501a17692d"
    sha256 cellar: :any,                 sonoma:         "d1f4b32a3efa0384e94acd7d538f650cd75892546632934ed2ca3660f5ff3ee6"
    sha256 cellar: :any,                 ventura:        "5411c7230909b5197a2265ca6c27662f4f3bf2ef4d43f51d0295e6ba048424ac"
    sha256 cellar: :any,                 monterey:       "d12e7ba83a3f1801c1c760706f20bb30e55b3d956758500bdee5ecd70646923c"
    sha256 cellar: :any,                 big_sur:        "322ef68983826e6c99be79b961a463d4d44023472594ab23643c2f03a7651fb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2fa26294b6a1a0bcd926744a98d23b582ddec574ea75012d287667dff6921e7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libuv"
  depends_on "openssl@3"

  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_BINDINGS=",
                    "-DLIB_INSTALL_DIR=#{lib}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-Dproactor=libuv",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "proton/message.h"
      #include "proton/messenger.h"
      int main()
      {
          pn_message_t * message;
          pn_messenger_t * messenger;
          pn_data_t * body;
          message = pn_message();
          messenger = pn_messenger(NULL);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
