class Ospray < Formula
  desc "Ray-tracing-based rendering engine for high-fidelity visualization"
  homepage "https://www.ospray.org/"
  url "https://github.com/RenderKit/ospray/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2c8108df2950bc5d1bc2a62f74629233dbe4f36e3f6a8ea032907d4a3fdc6750"
  license "Apache-2.0"
  head "https://github.com/RenderKit/ospray.git", branch: "devel"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "37889fb9d563aaffcfd8b7fee60874967a6d4d16e10f5a9947d629f977222c1b"
    sha256 cellar: :any,                 arm64_sequoia: "3df35dfd82214b9ee97e1a56a867d8c01c94f37537160d0e24b11b4656e94afb"
    sha256 cellar: :any,                 arm64_sonoma:  "a9aaf78d07b916b571a4d96eae5d4a570ef9bc0f63b9ec4a02a209798f425c9f"
    sha256 cellar: :any,                 arm64_ventura: "26c886271f141447de4017c2b469488c50f4a13ecaf825971a326dbf85ab8787"
    sha256 cellar: :any,                 sonoma:        "46f203d6c6db606e4fe48a8b63da54ece1badb1c4eae09cbcd842e297f6d04c1"
    sha256 cellar: :any,                 ventura:       "9d056ad5ebb6d60a81a44e64d5042870f8efb8579ea7b7e27e4ba4dc4f1545ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c0dbef40ef62c06ac0d81fdad78b51f2c2f4a1f81dc7a5f605abedf4c75ad57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ce0ebb61c0d3a09ce6e51d886f705e306b881d289fc9bbe62abe892b144532b"
  end

  depends_on "cmake" => :build
  depends_on "embree"
  depends_on "ispc"
  depends_on "tbb"

  resource "rkcommon" do
    url "https://github.com/RenderKit/rkcommon/archive/refs/tags/v1.14.0.tar.gz"
    sha256 "5aef75afc8d4fccf9e70df4cbdf29a1b28b39ee51b5588b94b83a14c6a166d83"
  end

  resource "openvkl" do
    url "https://github.com/RenderKit/openvkl/archive/refs/tags/v2.0.1.tar.gz"
    sha256 "0c7faa9582a93e93767afdb15a6c9c9ba154af7ee83a6b553705797be5f8af62"
  end

  def install
    # Workaround for newer `ispc` + `llvm` until support is added
    inreplace "cmake/compiler/ispc.cmake", "define_ispc_isa_options(AVX512KNL avx512knl-x16)", ""

    resources.each do |r|
      r.stage do
        args = %W[
          -DCMAKE_INSTALL_NAME_DIR=#{lib}
          -DCMAKE_POLICY_VERSION_MINIMUM=3.5
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
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <ospray/ospray.h>
      int main(int argc, const char **argv) {
        OSPError error = ospInit(&argc, argv);
        assert(error == OSP_NO_ERROR);
        ospShutdown();
        return 0;
      }
    C

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lospray"
    system "./a.out"
  end
end
