class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.5.tar.gz"
  sha256 "6b7994150bbc513abcdbe22ad778d6b2df10fc8cdc7035e916985b2a209ab826"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "447fa18ccaf04ecbcdf0d903c2cc111c4adf942738b41adb4b0558177aa09884"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a23d767a3a8b68540fa9984a758a0580f20273c68fa37589aeead31a43c6eb5"
    sha256 cellar: :any_skip_relocation, monterey:       "23bc006a34d949943bd11defb024dd5cd1c2dffc9d188c911117196d12728118"
    sha256 cellar: :any_skip_relocation, big_sur:        "818507956a19af5676e4482877bf6f8e3b230f062dcae5ae29490b1f46b3f960"
    sha256 cellar: :any_skip_relocation, catalina:       "5c5f6951c85dace70de82ecdcfee6bfa444b029e910377a1c6f6e3dce81bbae8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "457921bc7acf4f26b905699ef4c121878c10a8da3f85438c7fa04ff512384a24"
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
