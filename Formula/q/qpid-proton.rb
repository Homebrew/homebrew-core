class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.41.1/qpid-proton-0.41.1.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.41.1/qpid-proton-0.41.1.tar.gz"
  sha256 "03d9ba7f88c62524c125de8b1aff997313dcddb35e98c5a7927c0844842f9121"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/apache/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "af4de91f018373503206f573854b873c7d96def17b55c2ffa3748b4df6c4454a"
    sha256 cellar: :any, arm64_tahoe:       "b3fc6e974bf73feb50ee1d0633717827957124658f35e279191f338081f6a056"
    sha256 cellar: :any, arm64_sequoia:     "e7077ebdecc703db9776d8acaaf634846b5a28e73cffe174cea37e8cd6980b61"
    sha256 cellar: :any, arm64_linux:       "78bd4a8cdba4f54bf19d629a3fa259aefc6af60e0edae6b867937395bfc8ef60"
    sha256 cellar: :any, x86_64_linux:      "d5aea91f4d784aa8e93d13fa753eacbd624ff1ce08614c5e2ab8307633c2566a"
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
