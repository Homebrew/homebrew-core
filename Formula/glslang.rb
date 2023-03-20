class Glslang < Formula
  desc "OpenGL and OpenGL ES reference compiler for shading languages"
  homepage "https://www.khronos.org/opengles/sdk/tools/Reference-Compiler/"
  url "https://github.com/KhronosGroup/glslang/archive/12.0.0.tar.gz"
  sha256 "7cb45842ec1d4b6ea775d624c3d2d8ba9450aa416b0482b0cc7e4fdd399c3d75"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "MIT", "Apache-2.0"]
  head "https://github.com/KhronosGroup/glslang.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18dcb37366c463415b6197832e458496b07fa223b3c0b2b6e231badf726cd782"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72177c1ff9c71a3804e4a911048c7cd63fac4ca60e63ece278e1798dccf67abb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3db235a020477c9ba3f2bd70ac7dc57206bd56039bf8fd3f4db04dd850d2aef"
    sha256 cellar: :any_skip_relocation, ventura:        "180ceaa3d396248e1f14c413ccba50310bc84804c9cf7d5caece9706069edf85"
    sha256 cellar: :any_skip_relocation, monterey:       "dde8004da23f5b888a6592db77a97074b1c8ffe54a2b08fe4a696174f93298b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "222bf95cd2692ec34d55dc21fc313b366ca0a3236cb0646bfe5a7b0e7c663e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1630267f38b71703884ac867eb9e65fe11ea1418058b1ae74fcd26c5583aa9ff"
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
