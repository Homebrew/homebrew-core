class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.3.2.tar.gz"
  sha256 "69378768fe8325d2c6b73038ec5931b386d22e67029700ff5e2ff772e3e22fc8"

  bottle do
    cellar :any_skip_relocation
    sha256 "bd28417be354e304392e2f250266f751e8e314c566d18d54fc98420e0ee16cf5" => :high_sierra
    sha256 "9c611ff3a6beb43b25faf1250737db77325195defd98c4d2ef468c5b196f0c94" => :sierra
    sha256 "274ddcb4a4a6c99f6c35ed05775ae3f28ec61fa2f9f67b938055c7ea24ee8b20" => :el_capitan
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
