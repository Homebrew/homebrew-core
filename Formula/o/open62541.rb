class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "7fc8536c35c3582d459fd846da64d933473807f7de00de1d43766cee69882ed7"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "511f45210332216cced828852d7cd3a60ef69a7e27495f27f96a5f572274dbb1"
    sha256 cellar: :any,                 arm64_sequoia: "f8a94c2282e20ecdf23c62c467b04e54ad6b0a4697d0954797df93a31fdad6a1"
    sha256 cellar: :any,                 arm64_sonoma:  "f8e27578d29b00cf7af4467cd21b4d54d83b1e4170e0ba453bc06bbc352134b3"
    sha256 cellar: :any,                 sonoma:        "f508516ac1cc16bda53d610735ec26d270cadd9476aca184bcb0a948dce0eead"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ed4a6514c97dee976cb7757ec82f7a9f773c9fd95c05a35ac1b8b955cb1a22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd210c0fcbf2dba0c48383e012844a4648a9cee7721039f93c4b9a34170803c3"
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
