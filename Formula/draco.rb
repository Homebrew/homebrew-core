class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.1.tar.gz"
  sha256 "1e52f9d78f7f5d8c2d29e706dea751b2719fd795ee6e1e6259f6d5f8ac34666b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ffac6551b8acc71a2742dc24408458482a4117ec7304f073b3d6270b4c6b8411"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cd3af33c01146f9f2c60035120ad671eec5266d501e40828819710331db3ae4"
    sha256 cellar: :any_skip_relocation, monterey:       "db18b8ab9567ff78cfb11f69f32c4cd3d02b4c67afe4d2793110d2b71e2bc08a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7febd7092f8d0ab497635a7112f0290a109f9e43fc4ba5f8e6913b43fe15114"
    sha256 cellar: :any_skip_relocation, catalina:       "f1b36ce49e09addda5288c17b2632781e8360bb152c3dc30d8a5b2a1264ce4d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ce53a8a172b9e42fbed2316f23e6d7e710991259f9bdf7c7c8b6172f2decfa"
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
