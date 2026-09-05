class Libyojimbo < Formula
  desc "Secure client/server network protocol library for multiplayer games"
  homepage "https://github.com/mas-bandwidth/yojimbo"
  url "https://github.com/mas-bandwidth/yojimbo/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "df1b4894f9b90fe4d3a0bc4941fcdddb7a9b978c55d6c6bdee3f1edaf4cc28f7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "25131687cc074372cf6aab3706b52b7dd45b2b77b4a2f1612b04983bba8cd941"
    sha256 cellar: :any, arm64_sequoia: "cf2cbcb10f8b893bd5baa7d229d6fed7a2792ae498a11cebc3716e5250d26350"
    sha256 cellar: :any, arm64_sonoma:  "f3f20397cdb25bb684130b7c5e41f339928df211da6284ca508c5d14ee45e76c"
    sha256 cellar: :any, arm64_linux:   "16ddfb3cd385e022f00b599b371ca7499bdad6622b6a9f496660e01c3a329033"
    sha256 cellar: :any, x86_64_linux:  "f16478934220cd9543753b9881955d8f0946e1dfd5d3be7b824dcdf90892675f"
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
