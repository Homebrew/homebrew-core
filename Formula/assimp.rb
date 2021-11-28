class Assimp < Formula
  desc "Portable library for importing many well-known 3D model formats"
  homepage "https://www.assimp.org/"
  url "https://github.com/assimp/assimp/archive/v5.1.2.tar.gz"
  sha256 "17aff648d50dfd8fd07365684fe956812673044d759cfba28f8112bf98a2be7f"
  license :cannot_represent
  head "https://github.com/assimp/assimp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "50b38380e1bcf864f74b3d0512ed22b9302514cf23b1405b073f37588e67444c"
    sha256 cellar: :any,                 arm64_big_sur:  "fa7836872947f3e94c0ce2bef479188f6b11d1d5eb2de828eab49a1c0c82a0bd"
    sha256 cellar: :any,                 monterey:       "fb38e3e57e1cded0de722728d9537b58c19fb2bffd6d7cfba16942657f99575d"
    sha256 cellar: :any,                 big_sur:        "da87f310481dc74fc52e3c679869696278dcc58e8629d56dbc4b84710515def8"
    sha256 cellar: :any,                 catalina:       "652c965c646bae5a64d9ac8382accde938417d7d1111cbcd23fcd68b1ddd338b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ced187cbe7bbd7db639424ddef3ff3327861c41df91ba5f42fe82870d5e2cc58"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DASSIMP_BUILD_TESTS=OFF"
    args << "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", *args
    system "make", "install"
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
