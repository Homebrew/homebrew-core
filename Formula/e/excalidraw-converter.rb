class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "69cd238870b2d7497e998de0baa54675ea3ba71552b1364424376c6e3f265916"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8f4dde423d4f73a8dabb3441585fdf3648e76acaa427eafc8bc5e3bf9430cc36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8f4dde423d4f73a8dabb3441585fdf3648e76acaa427eafc8bc5e3bf9430cc36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8f4dde423d4f73a8dabb3441585fdf3648e76acaa427eafc8bc5e3bf9430cc36"
    sha256 cellar: :any_skip_relocation, sonoma:        "5971b0405ac66ed2051c5e19b5ab2f81fafda91cadea12c5d309b3856fc781f1"
    sha256 cellar: :any_skip_relocation, ventura:       "5971b0405ac66ed2051c5e19b5ab2f81fafda91cadea12c5d309b3856fc781f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9d7b79317941987ab8f9e11f175a76ef95b68f653b1b64ce8509d679f189090"
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
