class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "4717ae7deeecd2d595faa9b48d932c1f6fe8171b0301de631518e019e7f1eddd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "57f30ab07ae40917b47c52efbd8dace79807a463ebb2aac74e6998fce6309e28"
    sha256 cellar: :any, arm64_sequoia: "8705295ec966fc9f7e158484d4ebaa4f874a882e44d2a87b41cbf4cfd0127ef0"
    sha256 cellar: :any, arm64_sonoma:  "e4fe4f2f117e6bb5bf51a41908e915d6ee42df4b65927b2143ac44ade80c4d75"
    sha256 cellar: :any, sonoma:        "b9bc4c470cc3ab8970bed41c9f868403f910014f44820d3af04a6a0d59056771"
    sha256 cellar: :any, arm64_linux:   "72ceb0c2203c524220138136b1368a6d368ec3c5dcf49812db8c5b968ab718fa"
    sha256 cellar: :any, x86_64_linux:  "2702625c60c07bd9540603f388f53e6215ed8dd0a4d4bd672a29d5a1109c28a7"
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
