class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.3.4.tar.gz"
  sha256 "9f369ce924974acf9ab582fe8a9e50d86d54346460b0ac6d3808e3fcf269489c"

  bottle do
    cellar :any_skip_relocation
    sha256 "33644b5683c012afc0f80d16586323a70f4f493a9eeb5e94f28124dad10e0239" => :mojave
    sha256 "62e32fd392cc0a9dbf657f1ab10d45bfa73196094fb1ce3747b9028032e6b32d" => :high_sierra
    sha256 "c3c621506f20e04a61d1802562cb096c195880a47788a86b6e747c06a2c96500" => :sierra
    sha256 "588a6401cbb5ba4e74719fa589418a3f82da76b6dae44da357273fccdd2c3c4a" => :el_capitan
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
