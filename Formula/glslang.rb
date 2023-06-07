class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/12.2.0.tar.gz"
  sha256 "870d17030fda7308c1521fb2e01a9e93cbe4b130bc8274e90d00e127432ab6f6"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75d1cecc1f2fb1c7030ceff1772517f9d563747c9e18259cfe4b9c20948d1b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdcbba8258403e3e7e2fd6fc10ceb2fabd4596f24b7267aec3414ac98d0e6a0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9579fd6c58022ff2a108828ed7daac40679cbbac5b393ce8fb3ad7daba4d00ea"
    sha256 cellar: :any_skip_relocation, ventura:        "c990a6f629b7a69c0b60512494f931a602a263c7fe164fcc2ee9f5fe448bc35c"
    sha256 cellar: :any_skip_relocation, monterey:       "3bd33020710d50e30b92fd07054cded9267be650dd364b6d211166dc6c44b8bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d5abaa802ceade9518f8cefd0ba0a9b00e206ba5468e3fdf23ef1755376547d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64d08ca3d309408c30f339d84c60ac2a625a95c235394a9462931ce588324e51"
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
