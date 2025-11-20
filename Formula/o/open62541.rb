class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.14.tar.gz"
  sha256 "0a0a8830e4e5f720e901579f826c788fdbc3d49f44a9515ab15a06e877b59416"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b4e9c9187e98ed33128c29cbf85036df1794b6794b04ac8506d09513fbec4255"
    sha256 cellar: :any,                 arm64_sequoia: "a59ebcc71453d2a17f6a1bb19df9848d7bc8852f8c261f6cf4a572e2236795e6"
    sha256 cellar: :any,                 arm64_sonoma:  "683aee59dfd5fdda3a8ca2b26f0b6c22d1098ec4cff3517b0bfb7a44fdd04b30"
    sha256 cellar: :any,                 sonoma:        "fcbdfc7557252cc2b0ef202e34e827ed7fcced7aec5bd7a4f12d94ac6ef74ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d4b7f585a53c3f9a55a943bbc8bfa71425997c0c5c1f4ffc34b8606855a7416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66267f58eca111516b8c34a375c1510e78ece4173cddbfcb381da3b0feef056a"
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
