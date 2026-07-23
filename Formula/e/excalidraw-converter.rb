class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.6.tar.gz"
  sha256 "46981f7f023e975338f276efafa9bcb1e002ce406a7750f96a63ee2a090a277b"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1829ca17cd6537b8a672d120f9db8745190d25664221fd2363cab0a797551d68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1829ca17cd6537b8a672d120f9db8745190d25664221fd2363cab0a797551d68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1829ca17cd6537b8a672d120f9db8745190d25664221fd2363cab0a797551d68"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b57532cc245be4c864659bd0695e29db44627115b233a5bde74b11e14f23798"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77b8b020ba882d1d10b26897901d43006c7bb7eba092a80bab0eb7a606fb6f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e35123855532b6ff033094e8c763c8f19990f4c040c50db9d0fd5d08c80994b"
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
