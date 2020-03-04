class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.3.6.tar.gz"
  sha256 "80eaa54ef5fc687c9aeebb9bd24d936d3e6d2c6048f358be8b83fa088ef4b2cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "64a93005a9d93ee47b55138b99258e1bc2412c350f5fa0956343ad860b6dd167" => :catalina
    sha256 "c1bae68f6c01adcce21376bd26f66e9274fa5e733eed5b2e1e032a61e2641cef" => :mojave
    sha256 "fd67b398a18f03ed070ceb6cd3dccd58ce761e2030f6bc75599df3fb49a4d8bf" => :high_sierra
    sha256 "13422b36cce4d3e1541441d9a5c82539f13cbe0215cfab8b30c4ffaf43a12931" => :sierra
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
