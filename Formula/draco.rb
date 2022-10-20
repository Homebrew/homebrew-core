class Draco < Formula
  desc "3D geometric mesh and point cloud compression library"
  homepage "https://google.github.io/draco/"
  url "https://github.com/google/draco/archive/1.5.3.tar.gz"
  sha256 "7882a942a1da14a9ae9d557b1a3af7f44bdee7f5d42b745c4e474fb8b28d4e5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c3671a69a58b75e44ebba31b4fb959814a90d3a8fe37e066093493e3b8a8e0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5aa7bd55ef40f2f7e6c7ac7c0c6f1a2a0abfc85319ab9a125bac55fa25cf917"
    sha256 cellar: :any_skip_relocation, monterey:       "b17c66361bad70443be506ddf7c157d76bdd741ddffe9eee95bee91d7c5beb2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "318fd4fdcd7beb70556309dcc653d0bb5375c589c8e6d08b2fd2cf82b773cecd"
    sha256 cellar: :any_skip_relocation, catalina:       "889d24be914c95f6ec096a194894f84ad91f34a2218bd874055dd5c2b83cde6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d31d7fdb2a3b51488b2aeeab3e896842e268cdb58e5c6d0b4d80572e6c6060ba"
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
