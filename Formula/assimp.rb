class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.2.1.tar.gz"
  sha256 "c9cbbc8589639cd8c13f65e94a90422a70454e8fa150cf899b6038ba86e9ecff"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "312fe5c853d42c0852389f50c41fd1beb3c5216288df71672d0d19b65865f1ee"
    sha256 cellar: :any,                 arm64_big_sur:  "e6961f64964a73516526f1c15940609471cad8bb39ccc9ad9918aeeb1ec15856"
    sha256 cellar: :any,                 monterey:       "ebaa16a4799a68d6b28b87ef1ac257ba118de985fae0ce4bbbc9040cda939f32"
    sha256 cellar: :any,                 big_sur:        "c95d78cbf05ce78344ffac3ddf57a266f603155aaa895da3a6beac5884e8ee30"
    sha256 cellar: :any,                 catalina:       "a32c7c30d2e44b9af8aa66c015bdf46022e198cd3233bf65ba6212704b678ed2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65728a1e9d23e9d810217041fca6192370a8e1070bf97970356b450ed9b35b04"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args + %W[
      -GNinja
      -DASSIMP_BUILD_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    mkdir "build" do
      system "cmake", *args, ".."
      system "ninja", "install"
    end
  end

  test do
    # Library test.
    (testpath/"test.cpp").write <<~EOS
      #include <assimp/Importer.hpp>
      int main() {
        Assimp::Importer importer;
        return 0;
      }
    EOS
    system ENV.cc, "-std=c++11", "test.cpp", "-L#{lib}", "-lassimp", "-o", "test"
    system "./test"

    # Application test.
    (testpath/"test.obj").write <<~EOS
      # WaveFront .obj file - a single square based pyramid

      # Start a new group:
      g MySquareBasedPyramid

      # List of vertices:
      # Front left
      v -0.5 0 0.5
      # Front right
      v 0.5 0 0.5
      # Back right
      v 0.5 0 -0.5
      # Back left
      v -0.5 0 -0.5
      # Top point (top of pyramid).
      v 0 1 0

      # List of faces:
      # Square base (note: normals are placed anti-clockwise).
      f 4 3 2 1
      # Triangle on front
      f 1 2 5
      # Triangle on back
      f 3 4 5
      # Triangle on left side
      f 4 1 5
      # Triangle on right side
      f 2 3 5
    EOS
    system bin/"assimp", "export", "test.obj", "test.ply"
  end
end
