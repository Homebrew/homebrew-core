class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/ospray/ospray/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "d8d8e632d77171c810c0f38f8d5c8387470ca19b75f5b80ad4d3d12007280288"
  license "Apache-2.0"
  head "https://github.com/ospray/ospray.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "83a2eb52dc3a954cec96dbd1ad9fe82d7ea18e6ddcc304800f344e0210ed2608"
    sha256 cellar: :any,                 arm64_ventura:  "5ffc81abe610dfb975773f96aa5eb2425ccf455c830c568175141fdd30f81750"
    sha256 cellar: :any,                 arm64_monterey: "84ee9a6bf1b4c6feb7c531a2414197c47d3902b2821619f49de078835c27cc08"
    sha256 cellar: :any,                 sonoma:         "9f8cc433a1fb8a46d70e1c66f88246dd5fad7e95c45ceaca75ab3c184ccbdcc6"
    sha256 cellar: :any,                 ventura:        "a14930930e2f158a9751871dcb48b5a20a3e36af43a5fc8e21c81883650c9999"
    sha256 cellar: :any,                 monterey:       "5bc8a7cb0682ffd50311281d3e354cf4d6c9a680147b3af757aa7276135a2204"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7638362fd78b814886a4a47b19e8919567a95304d9c05325be5405e832db01"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/ospray/rkcommon/archive/refs/tags/v1.12.0.tar.gz"
    sha256 "6abb901073811cdbcbe336772e1fcb458d78cab5ad8d5d61de2b57ab83581e80"
  end

  resource "openvkl" do
    url "https://github.com/openvkl/openvkl/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "469c3fba254c4fcdd84f8a9763d2e1aaa496dc123b5a9d467cc0a561e284c4e6"
  end

  def install
    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DBUILD_EXAMPLES=OFF
        ]
        system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
        system "cmake", "--build", "build"
        system "cmake", "--install", "build"
      end
    end

    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{lib}
      -DOSPRAY_ENABLE_APPS=OFF
      -DOSPRAY_ENABLE_TESTING=OFF
      -DOSPRAY_ENABLE_TUTORIALS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
