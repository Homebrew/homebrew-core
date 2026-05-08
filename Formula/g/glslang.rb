class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.3.0.tar.gz"
  sha256 "efff5a15258dce1ca2d323bf64c974f5fca03778174615dbc30c8d36db645bf5"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd99a43cfaf561faf3503b990acec14c0bdb53f53f03b8c3d1130b5f4382b287"
    sha256 cellar: :any,                 arm64_sequoia: "39d78330b329675a2c72dea2cad0bcea6b88f3b2b7cec71badec87d5328d307b"
    sha256 cellar: :any,                 arm64_sonoma:  "26b340d94c04da2d20eae8bfb067d3db0a5848b211882b8ac57064bbd23cfd1f"
    sha256 cellar: :any,                 sonoma:        "77e333b928a4ccc4020b12a76e76075293be6144caceb6f6d7ebec8e987b33ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06ea9072fade813efe648a8d9e0b4e49adf70ec8b007691f53a8660745171f03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "27164f95b7738da40cd1bdb9473403fa0f0905d3259d3b65f7f14cf06655eeec"
  end

  depends_on "cmake" => :build
  depends_on "spirv-headers"
  depends_on "spirv-tools"

  uses_from_macos "python" => :build

  def install
    args = %W[
      -DBUILD_EXTERNAL=OFF
      -DALLOW_EXTERNAL_SPIRV_TOOLS=ON
      -DBUILD_SHARED_LIBS=ON
      -DENABLE_CTEST=OFF
      -DENABLE_OPT=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.frag").write <<~EOS
      #version 110
      void main() {
        gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
      }
    EOS

    (testpath/"test.vert").write <<~EOS
      #version 110
      void main() {
          gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
      }
    EOS

    system bin/"glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
