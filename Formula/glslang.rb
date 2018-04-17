class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/6.2.2596.tar.gz"
  sha256 "fce7ec22e66043fb59e4a3c369445ea8c57f2631a04b6a0015f19a7bc954567e"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b113e3ef8ccd8e18bae3a53d7ca409c1c8e0ba1e3b38f6dcf94b2d8917ea1a9" => :high_sierra
    sha256 "d5de78fc374f3c92cdf8f06f1518405346c63b42ffd7ad53bb153c27bd00a935" => :sierra
    sha256 "770943fa3e43b765e303cc88da1aa0bf2455f91cc0e84a636bfadd517cc87776" => :el_capitan
    sha256 "111206ad8b23ca9f78fa5657d371056e238f3eabf747d48001115d85f4ea88bf" => :yosemite
    sha256 "4d22c058983e127f3dbb02d86ef6d6cb94fcc5b87c5f3e46802b8b157d56e1c9" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
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
