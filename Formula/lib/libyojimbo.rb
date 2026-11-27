class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.16.1.tar.gz"
  sha256 "c1a76ac99c09f616584f72decec331bf705f5c6926901abee3baecc1d317fad3"
  license "BSD-3-Clause"

  bottle do
    manifest_sha256 "455bd35618c7a6d292911228967f3d45345066afeb168697f9606d0eaf1dde0e"
    sha256 cellar: :any, arm64_golden_gate: "db17a5c9b6d753eb28220e94687783f5ab42ed01abf556a546bf4b9b362b5cc7"
    sha256 cellar: :any, arm64_tahoe:       "e13c38a4023bb0fdb5d1fd48adc43a0622ffb546000ba404f6dc2692e9e97043"
    sha256 cellar: :any, arm64_sequoia:     "e4c60715cb83f4a2f675e860031521f5ff8a6847f530ce9668505e43ba881e66"
    sha256 cellar: :any, arm64_linux:       "a0cd9fe434d5f3e1ba9582a23d8864cb8c07d970adf3c9381e9a80058212a283"
    sha256 cellar: :any, x86_64_linux:      "788a738ee572728165be8d543038ee82347aab6954ca05cfb68a7e93b9f86137"
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
