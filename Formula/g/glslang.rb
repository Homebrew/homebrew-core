class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/refs/tags/14.0.0.tar.gz"
  sha256 "80bbb916a23e94ea9cbfb1acb5d1a44a7e0c9613bcf5b5947c03f2273bdc92b0"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "5fb3995691d8cee2e16f98245e847ba1cd555308d51e9daeda58ef960cb9382f"
    sha256 cellar: :any,                 arm64_ventura:  "58641a7b577f1d7490541750e0ab7215106b167bce2255132c85d9cdf94cbb2c"
    sha256 cellar: :any,                 arm64_monterey: "c755b3ac6b39d6bfd87575aaf963b6e215e7f7f75406df1fe9a2e344f67a3cc3"
    sha256 cellar: :any,                 sonoma:         "f95636647d6f1df77c5cbe334e280e7b72d85d1f2f06a9f4d376a3729170d2d9"
    sha256 cellar: :any,                 ventura:        "8ab644161f250ee72042178b78f529cdfed3c34c3a47fb8282196a7f31b35ce7"
    sha256 cellar: :any,                 monterey:       "2c97b0e775cf75e162318b8f4aa5c5a126006f0b5fe3836cc5fd43356967e971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f784a0957abf375541dae829f11468d1631ce6fbbbab72ed5b70a743dd8de501"
  end

  depends_on "cmake" => :build
  depends_on "spirv-tools"
  uses_from_macos "python" => :build

  # Fix SPIRV-Tools-opt dependency which breaks cmake files used by other projects
  # Remove when released: https://github.com/KhronosGroup/glslang/pull/3487
  patch do
    url "https://github.com/KhronosGroup/glslang/commit/f72a347e88737aee4977df709af322302decce20.patch?full_index=1"
    sha256 "7bb8e737792a534fbc65485688132318e4d29a507ec37667c5254b7afb7d2146"
  end

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
