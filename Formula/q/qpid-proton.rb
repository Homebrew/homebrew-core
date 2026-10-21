class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  license "Apache-2.0"
  revision 1
  head "https://github.com/apache/qpid-proton.git", branch: "main"

  stable do
    url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.40.0/qpid-proton-0.40.0.tar.gz"
    mirror "https://archive.apache.org/dist/qpid/proton/0.40.0/qpid-proton-0.40.0.tar.gz"
    sha256 "0acb39e92d947e30175de0969a5b2e479e2983bc3e3d69c835ee5174610e9636"

    patch do
      url "https://github.com/apache/qpid-proton/commit/7be093d8d96104caab3fa858ab9886f23d62ee04.patch?full_index=1"
      sha256 "472f573caf0ed1f545a9ed25a850d5117db857f9ce5cd1d0687022d98cc045f5"
      type :backport
      resolves "https://github.com/apache/qpid-proton/pull/447"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "56e55efa0b662312ed6acebb75e89b9e7244ffe75ce0a27b076cd513da752589"
    sha256 cellar: :any, arm64_tahoe:       "baa86a5bb46dc8a4f281ebcd100d98a68009a2ae82080906e4fbad89e78cfbf1"
    sha256 cellar: :any, arm64_sequoia:     "44cd2be3e3f85bb100810f107178230067e56f16a5fbffb383bc04fc37f8d9b8"
    sha256 cellar: :any, arm64_linux:       "ae96c75d3605093924d86cfc79b3420e978b5167781ca3ce00f417513274cb7d"
    sha256 cellar: :any, x86_64_linux:      "8d6e1966b7dc98ec6bbe237c64d8d609058148a0639af1e5c1ff65ca55cb764d"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "libuv"
  depends_on "openssl@4"

  uses_from_macos "python" => :build

  deny_network_access!

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
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lqpid-proton", "-o", "test"
    system "./test"
  end
end
