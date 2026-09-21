class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.6.0.tar.gz"
  sha256 "9c09b901149c729df745057dafa815278aaa101b84d2b6e14f16a42de52f97f2"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "dade50f46a565446c6117d85146e9009dea0189816e40538b547b0b6eb9ba983"
    sha256 cellar: :any, arm64_tahoe:       "8e5095c5d55b0500675deefbf8589c6e56cc777ba6f66f63e24a2c09b42710ea"
    sha256 cellar: :any, arm64_sequoia:     "e01d94f1d826e20d371db8a57de601128ebc273b6998eb87c038a3569153c78e"
    sha256 cellar: :any, arm64_linux:       "4ebcf1ec4dccea5ba915f05a2ca05306bc0bb55b2c124af9a20fa4c72ba131cd"
    sha256 cellar: :any, x86_64_linux:      "99ac0081b3bf04ae961638bed526d5e3e381f41084c2bbff79a1c639cd8820f9"
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
