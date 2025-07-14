class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.3.tar.gz"
  sha256 "99b66ce4cfc8ee2c6650b2fefa69a6a3cf8790267914492d2337a84e0c47b3d6"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fbf2a3cccd67292ad498e23cc277d71be3206d44d94b1460e47f35ce21662def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fbf2a3cccd67292ad498e23cc277d71be3206d44d94b1460e47f35ce21662def"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fbf2a3cccd67292ad498e23cc277d71be3206d44d94b1460e47f35ce21662def"
    sha256 cellar: :any_skip_relocation, sonoma:        "b505b20a3f8ec4f27cc8be1d9f225043b2ca3bfb7910d9b84759e06340af15a2"
    sha256 cellar: :any_skip_relocation, ventura:       "b505b20a3f8ec4f27cc8be1d9f225043b2ca3bfb7910d9b84759e06340af15a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1604d38d0eb30d65c5283b0b79b88293d1491f49967af15f6fc5d6e63474380d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X diagram-converter/cmd.version=#{version}")
    bin.install_symlink "excalidraw-converter" => "exconv"
  end

  test do
    test_version = version

    resource "test_homebrew.excalidraw" do
      url "https://raw.githubusercontent.com/sindrel/excalidraw-converter/refs/tags/v#{test_version}/test/data/test_homebrew.excalidraw"
      sha256 "87e06e6b89a489fe01ccd06e51b8cc2b73bb51ff02e998d04eaa092a025d64e0"
    end

    resource("test_homebrew.excalidraw").stage testpath
    system bin/"excalidraw-converter", "gliffy", "-i", testpath/"test_homebrew.excalidraw", "-o",
testpath/"test_output.gliffy"
    assert_path_exists testpath/"test_output.gliffy"
    system bin/"exconv", "version"
  end
end
