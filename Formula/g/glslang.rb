class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.2.0.tar.gz"
  sha256 "14a2edbb509cb3e51a9a53e3f5e435dbf5971604b4b833e63e6076e8c0a997b5"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa8e2a69d8570405d5cd1eeb4ed26fe220e03b618f0f4f91745b3ac89cc28efb"
    sha256 cellar: :any,                 arm64_ventura:  "beb6d03a1566fa02acddd72368c1bd632980697bc3d67563b32b511536392ee8"
    sha256 cellar: :any,                 arm64_monterey: "8321c28d1fe27cb23e27315184a0cd4d1f68aeb6da2d666f88e31bd44f3fabca"
    sha256 cellar: :any,                 sonoma:         "97632cebe4f409d9871454aa2904b4dc47f014ff41063c3fa54bac6b1bc68420"
    sha256 cellar: :any,                 ventura:        "f0ac392ab84be5ec228b51168da8bbebe08e8e05f31da8e5a784c146ac270aa7"
    sha256 cellar: :any,                 monterey:       "58430de8ff23719940a0d1a4087ca902e72e56851baef2428fe243ba637e9d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5af402e45fec6132350a474b433ee6450208b5dd72c72e6211bec0200fc6132"
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
