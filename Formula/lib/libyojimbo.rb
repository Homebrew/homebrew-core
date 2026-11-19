class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.16.0.tar.gz"
  sha256 "32e9284e3e0e6e1c1ed29b7bb6111a66c264b88db3263fd0cbed5d8ae6f24db6"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7baac9b9cdc4c7bab8f0671175f7c00c8d2936d13cdca2554330908b3d216eb9"
    sha256 cellar: :any, arm64_tahoe:       "a74c8f271f6939ed92b63fea885689b3dcb1d6f41cb832f814d3e26d6adb06ad"
    sha256 cellar: :any, arm64_sequoia:     "f266233588b9ea7e502bc325c5d7fc8d79ec5d5b4c7dbfc305421b1b8d2f943b"
    sha256 cellar: :any, arm64_linux:       "400d226e8ec94fa315a04169b116a59bb69d454fb59ade0fe8f13f6bfbbc1965"
    sha256 cellar: :any, x86_64_linux:      "bafc4941fc23fa34a0acd2318fcd65b8fd3598a011b61c2009780394634475bb"
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
