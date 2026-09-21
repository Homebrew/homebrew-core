class Coacd < Formula
  desc "Approximate convex decomposition for 3D meshes with collision-aware concavity"
  homepage "https://github.com/SarahWeiii/CoACD"
  url "https://github.com/SarahWeiii/CoACD/archive/refs/tags/1.0.14.tar.gz"
  sha256 "7a5d898c55a48668b19592a3bb8c5e3eb103836cda6883ca8955dfdce056d322"
  license "MIT"

  head "https://github.com/SarahWeiii/CoACD.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dee50cf0d994ff0fc85f41ec380819e93bb40d1da34b3753589791ab788146c6"
    sha256 cellar: :any, arm64_tahoe:       "d194038c80355410a913ceb685c0544b07ff4f77fe2251361b18bb8a8835ffdd"
    sha256 cellar: :any, arm64_sequoia:     "bffec5d5531cfe9ae7a130b058d4e115af8b65db76a55413ccb1c88e61d53706"
    sha256 cellar: :any, arm64_sonoma:      "fb69df8c84c40f0ae41b15b2026be14609731dd4260dfe4a120f19935cb59378"
    sha256 cellar: :any, arm64_linux:       "4a44845c7085a0dc5c2f0fa3c86cb077d3e02439276c9692b430464f7abc97da"
    sha256 cellar: :any, x86_64_linux:      "359d7abc44d591f0ddeff10e0f8fdbc38fe4fbf629ac55808d9e39b252e51316"
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
