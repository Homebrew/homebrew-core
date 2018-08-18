class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.3.4.tar.gz"
  sha256 "9f369ce924974acf9ab582fe8a9e50d86d54346460b0ac6d3808e3fcf269489c"

  bottle do
    cellar :any_skip_relocation
    sha256 "12615524f7d2a02dc205cc583a74af22e295d991319abd97b1c3d4bbeefd08c2" => :high_sierra
    sha256 "deceead0e090a64709966bdbd82056b26d7b494f995531af41382fd9d6af54f6" => :sierra
    sha256 "64bf9f616fcc812476a0674ce9bf742a93896de44e1b696a167e98a5a88e2f9b" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", * std_cmake_args
      system "make", "install"
    end
    pkgshare.install "testdata/cube_att.ply"
  end

  test do
    system "#{bin}/draco_encoder", "-i", "#{pkgshare}/cube_att.ply",
           "-o", "cube_att.drc"
    assert_predicate testpath/"cube_att.drc", :exist?
  end
end
