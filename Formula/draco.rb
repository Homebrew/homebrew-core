class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.2.tar.gz"
  sha256 "a887e311ec04a068ceca0bd6f3865083042334fbff26e65bc809e8978b2ce9cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3834c03caad06ebb5162b2c20cfd92902d9f55cdd3512c87b697d358a63908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "259e66dde7114bb53ae4dae50afa5bda67fbe74906532b04f620ba867478e0fc"
    sha256 cellar: :any_skip_relocation, monterey:       "b467c8e019187b235ec5068784293dc12ac8dd4a27ebb352ede5dfb22a3f25b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "576506a6847f7592b60af3acd2bcb27ebd04f27f28e15daa3abd7323369165ea"
    sha256 cellar: :any_skip_relocation, catalina:       "937cdfafc6ba6d0729342e51cb06b519b3cfb9d0a19a1980f44ca77d797b3983"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e419a6eaa005a6b450343066b185b3cdad19dfe4399bc51e96e6d7cfd3ecd503"
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
