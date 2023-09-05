class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "0751ce6273908b1e571f36591665f3d5b9451514c2478ea5f6b4b466d7da6b02"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "afde1ca3cd397d134ebab0ec50672610cdb59fb8924b0b033436d0c354eb81e9"
    sha256 cellar: :any,                 arm64_monterey: "a56cf8963234070ed92de7fd71e4119b57355b20e1bc84f0ad68e052e9afd254"
    sha256 cellar: :any,                 arm64_big_sur:  "204ac22c73e6c37950de0c8c6fddde0d71f8cc7fbe8b90fa1b5daee5384edd9b"
    sha256 cellar: :any,                 ventura:        "e9f4ab36dcb0ea074dba434713a2c51e0e540cf2bb1e4fa0fd7c0a3b61a35cac"
    sha256 cellar: :any,                 monterey:       "fd84a11308fc3a8981080dde285a5751a617d2c7f67791e2b664d2236b56333c"
    sha256 cellar: :any,                 big_sur:        "7363cfdc77e97a9773e3db69a104a277648a10e4b518c4e68c52cc2bc47ab8b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "027b5647f741b435d4168b13eb08db4ddbc7193587870bdd0c67bf033a23fedd"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

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
