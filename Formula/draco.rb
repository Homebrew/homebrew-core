class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.4.1.tar.gz"
  sha256 "83aa5637d36a835103a61f96af7ff04c6d6528e643909466595d51ee715417a9"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8102f60a854f4b5bd365b10f1c5876459424191052811d0afb42aa037c0ada7d" => :big_sur
    sha256 "834b335c5ea2e27b8256c6684fb1badeae6ad6b927436e329058dcbd51d85fca" => :arm64_big_sur
    sha256 "4a1088d41275a89ed0238d3eacca9740d9455e9fd2fcbf79b3147ad72c942b4d" => :catalina
    sha256 "45e5548e468c702c7508ec6f2ef7aa2c4862e38af9130511b36d910c069271a0" => :mojave
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
