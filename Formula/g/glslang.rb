class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/16.2.0.tar.gz"
  sha256 "01985335785c97906a91afe3cb5ee015997696181ec6c125bab5555602ba08e2"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "81924c6c819f9d643c33be3b3ee7f13f80ea92785aabe196439f791f7da752f6"
    sha256 cellar: :any,                 arm64_sequoia: "dc0515864df090407e1f04780264648a2d8ba285dbc9d151a29d53ed35e3d2e5"
    sha256 cellar: :any,                 arm64_sonoma:  "a2fab91a8da94e119a37d698d28bb924c7fb30c03413f77bd371a8eb6fe9b952"
    sha256 cellar: :any,                 sonoma:        "cdebed0b1446d431a203e5c1f3c0810dcfa78f7e3f592a1ca24b9de7071a912a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a69059366d774589e644eca0ce8a693fbc84c5c029275633ba78b1f378913f3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b623c9588fd39840421a180f4f5a9e04f9b630b2b50c3d03f33a0d3a98b6b67"
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
