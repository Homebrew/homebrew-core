class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/13.0.0.tar.gz"
  sha256 "bcda732434f829aa74414ea0e06d329ec8ac28637c38a0de45e17c8fd25a4715"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a232c95928f7290ca3e522767a4b78c8a82e987ce0e292b4048b26fc72f52a15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e2be96e21667fe8d9a8e460bfedc66ea987ae84ec6182f111fbf271f78575bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4fee0fd697e72808ead1fa38c3bac431c3900e6abce3ba0f7d863472428ba29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6052182c9e6abd813c18a588ba7ef068a112644245046c8e0323a7563d7c466"
    sha256 cellar: :any_skip_relocation, sonoma:         "a80c534eccc16d7131a9e9021492631976a61b63f8ac8b3b70baa3c20a73e4a5"
    sha256 cellar: :any_skip_relocation, ventura:        "73766c5f491747e8370345a13aca133fe72fed695ee243dd0ca635d08f42c117"
    sha256 cellar: :any_skip_relocation, monterey:       "1eb23999503d854e66c03ff5f286dc0b2bddd942cb7cb0f9e0b44be14f33666e"
    sha256 cellar: :any_skip_relocation, big_sur:        "792616dfb9a016c8d189796aa771b2cc0c88365229f03a23c1ff35e8c14b14d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd35b0b9c3e7262dc23bd0836d28b989951d7e155138ac4c9c826fe69dca532"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

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
