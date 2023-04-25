class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/12.1.0.tar.gz"
  sha256 "1515e840881d1128fb6d831308433f731808f818f2103881162f3ffd47b15cd5"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9a15340448276945770b05396d044a7648d280e4a7e045087a92dce466b31c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b73c8db8e315fc1a5cf6eb9051bfbe3494b3b849d7cdff3589c3a2e7318ace14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4c7f2388b5200b494fead562956716e0ca403620ac504be746595ab449bd2b8f"
    sha256 cellar: :any_skip_relocation, ventura:        "079634e447b8547d17a33bf0874d59521d2a3191681033183d27112bff4050a4"
    sha256 cellar: :any_skip_relocation, monterey:       "f1409be7d0d5625cb54e77b3ab50845ceb115985183f43060c7315a163bb82e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5fb6d738d5c0774fb90399f4f701c518d82f4abecb9ffbe37950cff0fdbefe6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf4f8f6aa74b15ae8bf6a12fbf0947366bfc7d1fbb4b8a470c4435f18de5593"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DBUILD_EXTERNAL=OFF", "-DENABLE_CTEST=OFF", *std_cmake_args
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
