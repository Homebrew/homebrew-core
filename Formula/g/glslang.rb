class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.5.0.tar.gz"
  sha256 "01af17195fbeb59e39e31e9506de35bb39dfd35807ea0c9a1a99d7d1183ddd45"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  compatibility_version 1
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b14c788c5c9c3fd1b115a1ace94e0c88394830906b303415f4099ed6ee34dec4"
    sha256 cellar: :any, arm64_sequoia: "878541e1f3d9aac590992db34e7f7738a3d596d80b00074c17a786c74a99776e"
    sha256 cellar: :any, arm64_sonoma:  "03fb2c015a54b7674d6ed5c6feb57ea75df30b79a9249361e3ac25f91c04466d"
    sha256 cellar: :any, sonoma:        "42735380880b59539e319bb51d6c3444520adf310c933f5624cc61a73e36400e"
    sha256 cellar: :any, arm64_linux:   "35aa345c2298c4de03542b1a3007c8fef93014e57ce7bb4b6cb8e75b6b0754aa"
    sha256 cellar: :any, x86_64_linux:  "465e795f4b6e62d9d342107c7e86bfa6337012405a982d1e3181d79c012956be"
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
