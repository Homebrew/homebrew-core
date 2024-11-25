class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.8.tar.gz"
  sha256 "b0e83206eb1c80c646d8fbd3fc70eff4de5b72cfba895d6629572559db43414b"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "556438ffd7d6c22c59a3810e127f84687c32f23c32d68df04a3370b08ba68908"
    sha256 cellar: :any,                 arm64_sonoma:  "e06658e7531295dddb392ae28c5d4c0e7b5ec281a9290c08bb29361fe83657b9"
    sha256 cellar: :any,                 arm64_ventura: "81662bd730b0949483f1f7a363ab35cf16c23b94802bcf36e295e289a80fefd3"
    sha256 cellar: :any,                 sonoma:        "3d975dc67225da60fde192469a1e668bf154db670aadec0deb073fa742ae7913"
    sha256 cellar: :any,                 ventura:       "d1a57af84d9fe6630eef66e29d541dbf4db62a2274456f4c5ef489ce14d60c54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0ce17735d42c789871a50ca75e439ce959cea4862821942086717601aac44c"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  def install
    cmake_args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DUA_ENABLE_DISCOVERY=ON
      -DUA_ENABLE_HISTORIZING=ON
      -DUA_ENABLE_JSON_ENCODING=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *cmake_args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    C
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
