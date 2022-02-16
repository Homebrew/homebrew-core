class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.1.tar.gz"
  sha256 "1e52f9d78f7f5d8c2d29e706dea751b2719fd795ee6e1e6259f6d5f8ac34666b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d4e964fdbd1e9f7248f2e8c06c415814d5b2ab4975ebfeb295d18b5cce0de72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "250b6812385d2f87f807f09c82db196c90f78f3d6f0aba5c740b96bcc6da6b0d"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7a0fa0ed837eb9a3243a634f39b56ae52ac1fec316db20a431a20b3e7c39ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcb5df911dfcf1626b659e7eae4d0c6f9147bf7f69fbb4b4ae21c7493a41c430"
    sha256 cellar: :any_skip_relocation, catalina:       "4c67284d5681cf6547028130b95b1cc60ce10e14de87d9e27f5c085cdcc72790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8127079347d1101c647c45eba877027fdb15ef62afc56d3bb0d3b8427d14b33c"
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
