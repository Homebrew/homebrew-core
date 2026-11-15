class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.15.2.tar.gz"
  sha256 "801b98b6c83af560b2430fce542524939e50210f2964615fed07d5b551f1b269"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d73e8d35d3a5bb802769282e8931ee51fa58717e5623a50839c28d6c47467288"
    sha256 cellar: :any, arm64_tahoe:       "6e4071f940d8c684d98a9d6edd6465fd46eb77571cb20d2fa9d89c7bed1b2d95"
    sha256 cellar: :any, arm64_sequoia:     "79ddbbfc0fc39af07220bf75f57432a9f61bba015e79d1cd0cf5b27a9c9035b7"
    sha256 cellar: :any, arm64_linux:       "4a4e995d1a388eef044c79bd8ccf72d82228ae07b2c8d617d9d9c0d6ba1458b0"
    sha256 cellar: :any, x86_64_linux:      "2c82459604d000e69954c8acb2f77efc27e4634b1d6b95c168da98dc5edb255a"
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
