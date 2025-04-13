class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.4.5.tar.gz"
  sha256 "6b8a457b11a1946627de01f948adf1465b179447aaa7b4435dcbd492f4c15afa"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "feacb7917a2b592fbef4e2ed7c09b6fc5e6ba0d190b8d6acf6d6a15176147c6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feacb7917a2b592fbef4e2ed7c09b6fc5e6ba0d190b8d6acf6d6a15176147c6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "feacb7917a2b592fbef4e2ed7c09b6fc5e6ba0d190b8d6acf6d6a15176147c6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "6334ab45ea587fbcc8a3ff78c17c9f825e861136332a579bf4d89623df61a23a"
    sha256 cellar: :any_skip_relocation, ventura:       "6334ab45ea587fbcc8a3ff78c17c9f825e861136332a579bf4d89623df61a23a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751c2615c2b14ce1d83ab9e837db24aa967d433a939411245aee99efbc4dddd3"
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
