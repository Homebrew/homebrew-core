class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.1.0.tar.gz"
  sha256 "b5e4c36d60eda7613f36cfee3489c6f507156829c707e1ecd7f48ca45b435322"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81fbdb7f4e7edcca47adc9337c31ebc7f1d6d7f3c9b67867b872312929212ae8"
    sha256 cellar: :any,                 arm64_ventura:  "349076703938e47853112c7aaf29dccac29afe2ce6e5a6134887a2e7a46f9d8b"
    sha256 cellar: :any,                 arm64_monterey: "33ea41abdedb8461aaf9cf4f29be8db9095b33cbbd8cc23b62aed9f337bacfaa"
    sha256 cellar: :any,                 sonoma:         "dafc35c34e646d0174c8520d5e536508a106e7c898188187b281c2bee5df2d79"
    sha256 cellar: :any,                 ventura:        "fb7d821023a42b9650d4a0a84f59943d7cb15f9436bd08b232b6d181de8b084b"
    sha256 cellar: :any,                 monterey:       "b80d3475b5ca869c8868bfbbbe55d9471d403ff896bb0be13a3e34b60bfa6c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5675952d5fb1d20301e68599ade2515e625aadb545e280fc6c5d04a8a7f04116"
  end

  depends_on "cmake" => :build
  depends_on "spirv-tools"
  uses_from_macos "python" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_EXTERNAL=OFF",
                    "-DALLOW_EXTERNAL_SPIRV_TOOLS=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DENABLE_CTEST=OFF",
                    "-DENABLE_OPT=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
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
    system "#{bin}/glslangValidator", "-i", testpath/"test.vert", testpath/"test.frag"
  end
end
