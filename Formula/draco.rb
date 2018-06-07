class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.3.2.tar.gz"
  sha256 "69378768fe8325d2c6b73038ec5931b386d22e67029700ff5e2ff772e3e22fc8"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b73805e35ecefeb462ff25289d4b7287bfafe5af10b153d12e16b896d7f7ffb" => :high_sierra
    sha256 "26c5746a61775c4bc620366938630c4a6aa38ae19d772b7fb95242ac88264a91" => :sierra
    sha256 "aeb65a69bc9acf8296b5853f49a9595af3d7d033efabd7947922fb00c4e9808d" => :el_capitan
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
