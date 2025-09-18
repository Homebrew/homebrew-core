class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.13.tar.gz"
  sha256 "491f8c526ecd6f2240f29cf3a00b0498587474b8f0ced1b074589f54533542aa"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c3ad446dbaa6cc2582ceb7165e6069e7765abe93bd3151b60e9ee12ae8a01435"
    sha256 cellar: :any,                 arm64_sequoia: "2af9b81e50d603216505d07eaa8481ad9a6317ecc354c72093274d9723f968b0"
    sha256 cellar: :any,                 arm64_sonoma:  "aada8c113540f978af6d5c4a763c116d765826c8a0059343d301da9b19448094"
    sha256 cellar: :any,                 arm64_ventura: "ad70816a67523e5cab47075ccd220badcb8b65f31cfc55089cf9b60c8de0d8d8"
    sha256 cellar: :any,                 sonoma:        "915b697e025a576dc8bc3475f1c70a6716ab8af9b477d0d64015741e1f97586e"
    sha256 cellar: :any,                 ventura:       "fa7539473522ce02a705794967260ea4cca1ab84f20f1fe50f92c35d752c92f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c1c40afb3f7619ff0525f3fc914bcd6e910ba23cbdd8b0dcb4c80454673ce2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f91ca72f7423a6c39ebf27f8f4b82e02a2af61e5f7865697a33ddb00bf1e841c"
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
