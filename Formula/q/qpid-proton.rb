class QpidProton < Formula
  desc "High-performance, lightweight AMQP 1.0 messaging library"
  homepage "https://qpid.apache.org/proton/"
  url "https://www.apache.org/dyn/closer.lua?path=qpid/proton/0.40.0/qpid-proton-0.40.0.tar.gz"
  mirror "https://archive.apache.org/dist/qpid/proton/0.40.0/qpid-proton-0.40.0.tar.gz"
  sha256 "0acb39e92d947e30175de0969a5b2e479e2983bc3e3d69c835ee5174610e9636"
  license "Apache-2.0"
  head "https://gitbox.apache.org/repos/asf/qpid-proton.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fb2e582995d74fa3b379e8e4d895fbf0d8ddd291cdb79e9d8d11c82e42180da1"
    sha256 cellar: :any,                 arm64_sequoia: "ad2d0628f2d4cfca80bd45f29612ec776c48de10a3f4f49f65e8c7f4cc2bbe0d"
    sha256 cellar: :any,                 arm64_sonoma:  "80e748066920432d06e1ef02053cf91ca25126f72432c7cb48d4b58d70b0213d"
    sha256 cellar: :any,                 arm64_ventura: "7ba2629ad9f29a3fdfc38b9400f805fb598d68a9740cb1f950bb27a21ceaea9f"
    sha256 cellar: :any,                 sonoma:        "91a726082f6b056f11bf05f702270977a08c3c3d842f1e5ecc3c0e6501501dcd"
    sha256 cellar: :any,                 ventura:       "7dcf7fac3dc9cb98a388b4e7fa0c0ca9c33897f5fa0657afadc55fd018eb84e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "264e02d20e0fe761f2c866e52d21955063c016c58841a8333255cf70a8d677f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "529a54660787834c31b10aae535c4b99faf146b5f567715f9a44e06fdc3b37b0"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
