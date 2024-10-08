class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "bc4ad185fec5c257e15fcb813b7fef9607b7aaa5d355de7b665e1f210556d38e"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fcb78df771635b393cb6315007592968eaa5512d61c03d58f5e4dd10a6ccf7a9"
    sha256 cellar: :any,                 arm64_sonoma:  "197c38cbacf127962d28325d32b3551e7603caf61b1d1777ca423ad54f6ad4d0"
    sha256 cellar: :any,                 arm64_ventura: "26b7ad40542e8c3aad61b974c1b6269f1c97460137f951b5040d1910c848aa85"
    sha256 cellar: :any,                 sonoma:        "238ff47ff6d3c7f22c0df5821c4ac5918d0f6d9e73b233d933774d61f843d3e5"
    sha256 cellar: :any,                 ventura:       "22cf5d33e7d21ee238dd3dbbd811472a114e89364cebb85ccd65ef7fe33b8581"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9194b8510ca203da444ad350c18da3f4231c17632d0ed7fdfe490c4894abff0a"
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
    (testpath/"test.c").write <<~EOS
      #include <open62541/client_config_default.h>
      #include <assert.h>

      int main(void) {
        UA_Client *client = UA_Client_new();
        assert(client != NULL);
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test", "-I#{include}", "-L#{lib}", "-lopen62541"
    system "./test"
  end
end
