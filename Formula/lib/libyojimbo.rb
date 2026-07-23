class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.7.0.tar.gz"
  sha256 "b1266d2a08f147518ee6379af81a1477c39b2650c32c94f1125c4178f8ea6cdc"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b79226cffd0d1c3b0ace62b9aee93cb528dedf7069496e1eb3172a5f6327cef4"
    sha256 cellar: :any, arm64_sequoia: "7732c33e4fc0e9c345f1bca1d022e6fa840fcb90b6e82b66543b970062f44963"
    sha256 cellar: :any, arm64_sonoma:  "ed1f2a8fc63236d89bef334713e7f96ec04dafb5ceafcc5f9f7b08c0aba8742a"
    sha256 cellar: :any, sonoma:        "8c62a8d14b112da705338a273d34903af0892b7eab3fc8af37ee4bcb934b14cb"
    sha256 cellar: :any, arm64_linux:   "33f5fb7d5221985ad05f7c1070fa243002087b786f7e29db98bb5f3b186b6f58"
    sha256 cellar: :any, x86_64_linux:  "a938ab80654089013635f3b12d6e2ead9c5179f4943d5604f2998dc6a0f3c5b5"
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
