class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "a787c7bc79d8e8ee83483be0309ec898a297581c4a20afb4033c601bb8dcd715"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "500d773c61d4493c4235b86af90a95a760c2b8fdf017e2ee01a47e5ce18806e1"
    sha256 cellar: :any, arm64_tahoe:       "d6b2460c9d3b113bda6068658a2929cbbba7c1e0d3648e479a2103537f189ed8"
    sha256 cellar: :any, arm64_sequoia:     "6a24abefb5f49247d34cdc296a2e5555742c8bcfee29030f2e70c8e94b732426"
    sha256 cellar: :any, arm64_linux:       "63adc4bde1768ed69e2f15fbc0b40bb6a3c909bd4b7fa5571feadfb190625f79"
    sha256 cellar: :any, x86_64_linux:      "47b01c432523c8e8551f19077b7e3f731322b849bae7c8d795f8a7f4753aacfe"
  end

  depends_on "cmake" => :build

  depends_on "libsodium"
  depends_on "netcode"
  depends_on "reliable"
  depends_on "serialize"

  deny_network_access!
  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DYOJIMBO_SYSTEM_DEPS=ON",
                    "-DYOJIMBO_BUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <yojimbo.h>

      int main() {
        if (!InitializeYojimbo()) {
          return 1;
        }
        ShutdownYojimbo();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lyojimbo", "-o", "test"
    system "./test"
  end
end
