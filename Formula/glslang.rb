class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/11.7.0.tar.gz"
  sha256 "b6c83864c3606678d11675114fa5f358c519fe1dad9a781802bcc87fb8fa32d5"
  head "https://github.com/KhronosGroup/glslang.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e38c1f6c03334608592a1e5c100bf3fdca2fc26a162a4bd6c77a17623d2bf51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc17863e922e4f6c96b4cacceab7787bbb52b9af1e419cd489f7813df1e2b042"
    sha256 cellar: :any_skip_relocation, monterey:       "060fedf7ace75ea554945d566286cfa97c8d439e434bfaa526f5ab70ef6673d9"
    sha256 cellar: :any_skip_relocation, big_sur:        "83925daf8b84cf8aca2dfe25c4411e4acc94e3960901b0f0d03a3509b234e8b9"
    sha256 cellar: :any_skip_relocation, catalina:       "b260bbfac67ae175dcce1471620a6b631fdcfa5eb9a7b9592f080027f808b085"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c51c25b27df4aeb6fed73289dbb3529a190cf2da5353ae696a0217cde6d3a4b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  def install
    args = %w[
      -DBUILD_EXTERNAL=OFF
      -DENABLE_CTEST=OFF
    ]

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"
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
