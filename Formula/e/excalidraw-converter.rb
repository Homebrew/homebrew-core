class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.2.tar.gz"
  sha256 "826087fecbfd48c5e0d832a342ba66c2cb74c06e5736218e199a2f531f1aebb9"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "63190c78be2ad83ec102ce1ef9172e6d7833557bc0e03dc754dab59f9a18f8dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "63190c78be2ad83ec102ce1ef9172e6d7833557bc0e03dc754dab59f9a18f8dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "63190c78be2ad83ec102ce1ef9172e6d7833557bc0e03dc754dab59f9a18f8dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "782bbc476a600ac2d9de367f9523d9c1d5db68ab6d0c6f8b2045e80670714eef"
    sha256 cellar: :any_skip_relocation, ventura:       "782bbc476a600ac2d9de367f9523d9c1d5db68ab6d0c6f8b2045e80670714eef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2539667eb80a0c88d3366d2c65dd7c0d3d505d8bc38ef6724ef5d6eec8f3f074"
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
