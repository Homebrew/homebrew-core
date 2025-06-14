class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "3bd151708755baed423e83d2875f3007ed065ba8acf5bf581b0157a88ce7c7bb"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "448cfb1341c199b0af316f3aacf70df35e6591c62998ca8c69887a9928d8519e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "448cfb1341c199b0af316f3aacf70df35e6591c62998ca8c69887a9928d8519e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "448cfb1341c199b0af316f3aacf70df35e6591c62998ca8c69887a9928d8519e"
    sha256 cellar: :any_skip_relocation, sonoma:        "27be56ebef4c224799182b98f021c49bf51e5dcc91ae077c1ff30240ded6d79e"
    sha256 cellar: :any_skip_relocation, ventura:       "27be56ebef4c224799182b98f021c49bf51e5dcc91ae077c1ff30240ded6d79e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "676e903891c0aee8a518fb16670d105c460b639c1c9d5ddbf1bc5856923f37b3"
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
