class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/3.0.tar.gz"
  sha256 "91653d09a90440a0bc35aa490d0c44973501257577451d4c445b2df5e78d118c"
  head "https://github.com/KhronosGroup/glslang.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5de78fc374f3c92cdf8f06f1518405346c63b42ffd7ad53bb153c27bd00a935" => :sierra
    sha256 "770943fa3e43b765e303cc88da1aa0bf2455f91cc0e84a636bfadd517cc87776" => :el_capitan
    sha256 "111206ad8b23ca9f78fa5657d371056e238f3eabf747d48001115d85f4ea88bf" => :yosemite
    sha256 "4d22c058983e127f3dbb02d86ef6d6cb94fcc5b87c5f3e46802b8b157d56e1c9" => :mavericks
  end

  # Fix: Failed std::map static assertion with libc++ 3.8
  # https://github.com/KhronosGroup/glslang/issues/368
  patch do
    url "https://github.com/KhronosGroup/glslang/commit/ec1476b7060306fd9109faf7a4c70a20ea3b538c.patch?full_index=1"
    sha256 "36e8986d8e506f3b85e652a048b3039d2758664f0068c6e466af314e9096a0b6"
  end

  # Fix ordered pointer comparison build warning/error
  # https://github.com/KhronosGroup/glslang/pull/108
  patch do
    url "https://github.com/KhronosGroup/glslang/commit/a3f53e54d232f3bb345b501ab30a01a5507e5b4e.patch?full_index=1"
    sha256 "0b25f25119eaf2abb62cd743fc47b587df18e12c69dbc84f4593d7992935e586"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"

      # Version 3.0 of glslang does not respect the overridden CMAKE_INSTALL_PREFIX. This has
      # been fixed in master [1] so when that is released, the manual install commands should
      # be removed.
      #
      # 1. https://github.com/KhronosGroup/glslang/commit/4cbf748b133aef3e2532b9970d7365304347117a
      bin.install Dir["install/bin/*"]
      lib.install Dir["install/lib/*"]
    end
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
