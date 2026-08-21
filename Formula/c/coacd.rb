class Coacd < Formula
  desc "Approximate convex decomposition for 3D meshes with collision-aware concavity"
  homepage "https://github.com/SarahWeiii/CoACD"
  url "https://github.com/SarahWeiii/CoACD/archive/refs/tags/1.0.13.tar.gz"
  sha256 "0e9e875fc55e6e399d4691cc4a47e36d0f64d076937de6f78bc7c4aa28bb472b"
  license "MIT"

  head "https://github.com/SarahWeiii/CoACD.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e2cdb593865c4be52a7f5a7129893dd8198c421258abd7c8b7ba6cd5c17bb098"
    sha256 cellar: :any, arm64_sequoia: "c32f5f6c1f2bbe66dccfe486f5a9fe3771691bf1807d72dd4f8edb3c045af7b0"
    sha256 cellar: :any, arm64_sonoma:  "8fab80ee535fe28c5121c61c258e54e544373c8e516f4feccb8070785fae5337"
    sha256 cellar: :any, sonoma:        "d2996af51734b5d1f4329f5bcd8991bbe8544adeddd2b6a3a3338b39101a12a4"
    sha256 cellar: :any, arm64_linux:   "17d70e43ee8b450f47a1d33a34adb495d95c55506739a2a14959ded6b7da22b0"
    sha256 cellar: :any, x86_64_linux:  "24748509bb5d113c63b82352df1c965f45269581cf373d4e3169b8e725422962"
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
