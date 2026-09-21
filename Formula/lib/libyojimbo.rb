class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.13.5.tar.gz"
  sha256 "ff78348e6ce6fa47b94c826516b4d8ca55f5b0d3aa4d0be1adc10ed80fdcbeb1"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c59c947fc777229e8c413b2e895f3080824fe38af9998e3d97d9ac2f820307d7"
    sha256 cellar: :any, arm64_tahoe:       "a3e543b13a5481450f3ed01d722efcd1c8019b5abcfbe3e765e76582a8b97542"
    sha256 cellar: :any, arm64_sequoia:     "8ccc387b66e859e70d55fa8641178c92eeb6773b5e988d4c8a048faff5b64eb1"
    sha256 cellar: :any, arm64_linux:       "a558bbf26bcc78a0cdf53c67a675ff52f74438c5378b13a30bd6dd81571dc751"
    sha256 cellar: :any, x86_64_linux:      "13c2c39f83cb5b2ab623d4b7f40db1b582c2ff7872bc374245a5c93093c33ca5"
  end

  depends_on "cmake" => :build
  depends_on "libsodium"
  depends_on "netcode"
  depends_on "reliable"
  depends_on "serialize"

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
