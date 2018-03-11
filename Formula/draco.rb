class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.2.5.tar.gz"
  sha256 "76064614bcf5bc80c13291d38c2ea7b8e9c8827a98de93f7bc8bbe4b6e1ec1c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "e73a9122f2fe8ff15eeb35fc43042c143ebab42ec7ae23ab03358a9cd307b099" => :high_sierra
    sha256 "26e8d3e692983b81b862784d788bdd31644da8efdbf68b9b5f069cf2bdfcb804" => :sierra
    sha256 "b6da06e26c080eab8b1a565d24cb1c9ed0a42f2a542aebc39f121a9be49db7a1" => :el_capitan
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
