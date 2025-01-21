class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.4.9.tar.gz"
  sha256 "8735e61391cde0d84e6347a4293d2400b6a72838fb44513caf22d70dfca3a0cf"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "89d09102e2f31d95ee3c67696e8ec74a7771e47de7ef386d96d4029f39125f94"
    sha256 cellar: :any,                 arm64_sonoma:  "7f32a56e1034927481e907575462c1bd92fcc590b7b51c81d08155dc84864617"
    sha256 cellar: :any,                 arm64_ventura: "1a09930cae916bffce52dec0e305ec0354023f7f1082a9d692b255500b6cc46f"
    sha256 cellar: :any,                 sonoma:        "4601c3f191764e7eb7e76cceb82e4f09cd839511ef6e679fd151216b0c0acbf9"
    sha256 cellar: :any,                 ventura:       "f1e926a44b53ee2ffe4a59abbf25665a11051c46d54098ab62910885f1ae78e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62ef12fae4c1b878204994a6bf8197e5eff7fc51cc875929dd560e08f2cbce32"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  # fallback to a normal static mutex initializer for macos builds
  patch do
    url "https://github.com/open62541/open62541/commit/ddff3a1bd33ccbda6456d9ae2c2d408ea718b47b.patch?full_index=1"
    sha256 "1f361b583baa3396833370463f2f95fdbac11ed8dda586ac9f3489439590dda1"
  end

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
