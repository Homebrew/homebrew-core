class Coacd < Formula
  desc "Approximate convex decomposition for 3D meshes with collision-aware concavity"
  homepage "https://github.com/SarahWeiii/CoACD"
  url "https://github.com/SarahWeiii/CoACD/archive/refs/tags/1.0.11.tar.gz"
  sha256 "6c57131f3c572afc52b6057a97f4e8b81b010b6bdffb610ca2dd3d418cf6de6d"
  license "MIT"

  head "https://github.com/SarahWeiii/CoACD.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "951caf0b3d97f15ed48d21c5b955a3102178e7ec3ae3be32ebb9e2a4ab21362a"
    sha256 cellar: :any, arm64_sequoia: "7b552e4db4a07c91fb065ccd115fe9aa70b342aab4aaafb8fbd8372d1f85a223"
    sha256 cellar: :any, arm64_sonoma:  "45423800e58ce132c6d0f74f999eacfbf1b788200458d5ecf979b9da77336129"
    sha256 cellar: :any, sonoma:        "8b8592eef25dfb6b8230f52331274fb8aea502a6e8d4b94da481d9d7aabade4e"
    sha256 cellar: :any, arm64_linux:   "b23433ced3cd62361c95dccf77c267ff81119bb56415bec2ccd1dd3ee3883a2b"
    sha256 cellar: :any, x86_64_linux:  "e5f8111838643c8fa191a3a0cdd8609f42f8717cc9c91d98023cad4febeecc8c"
  end

  depends_on "cmake" => :build

  resource "cdt" do
    url "https://github.com/artem-ogre/CDT.git",
        revision: "ec03b309fd18102ab1da069f2edf3b37be5d1fb3"
  end

  def install
    resource("cdt").stage(buildpath/"3rd/cdt")

    args = %w[
      -DWITH_3RD_PARTY_LIBS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <CoACD/coacd.h>
      #include <cassert>

      int main() {
        coacd::Mesh input;
        input.vertices = {{0.0, 0.0, 0.0}, {1.0, 0.0, 0.0}, {0.0, 1.0, 0.0}, {0.0, 0.0, 1.0}};
        input.indices  = {{0, 1, 2}, {0, 2, 3}, {0, 3, 1}, {1, 3, 2}};
        auto result = coacd::CoACD(input, 0.5, -1, "off", 50, 2000, 20, 100, 3, false, false);
        assert(!result.empty());
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++20", "test.cpp", "-I#{include}", "-L#{lib}", "-o", "test", "-l_coacd"
    system "./test"
  end
end
