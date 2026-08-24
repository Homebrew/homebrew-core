class Open62541 < Formula
  desc "Open source implementation of OPC UA"
  homepage "https://open62541.org/"
  url "https://github.com/open62541/open62541/archive/refs/tags/v1.5.7.tar.gz"
  sha256 "a4018b052c93fedb55f00558a85869b86f3bb2293184d322e33f2666c497eaeb"
  license "MPL-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4981f43e761a4c863702f59e84c9311494ea4269283d07bd8ea1221be70b8787"
    sha256 cellar: :any, arm64_sequoia: "cc3e2b03db580642a6c01f970f520de63faece5600bb9938ec63bb98cb81180c"
    sha256 cellar: :any, arm64_sonoma:  "1b6a0e97b2593c001d0eec9f6286a8581abeba7094d69d293ef73982ef5ee961"
    sha256 cellar: :any, sonoma:        "fd850f50abe576051ca6779aa94e56852c11745bfa17d7007fb9ed68e69d1fbe"
    sha256 cellar: :any, arm64_linux:   "3558b1ad5c8fd22cf7a80e535af099b744fb2886a72317e92c689efb50cf5175"
    sha256 cellar: :any, x86_64_linux:  "23cbbcd206dc5dcefb9be2a1a77d09d259ce55fa2121a8e7f2eca9e107863946"
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
