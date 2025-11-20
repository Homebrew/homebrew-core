class ExcalidrawConverter < Formula
  desc "Command-line tool for porting Excalidraw diagrams to Gliffy"
  homepage "https://github.com/sindrel/excalidraw-converter"
  url "https://github.com/sindrel/excalidraw-converter/archive/refs/tags/v1.5.4.tar.gz"
  sha256 "ae4c9da1d9710a3bd2895730852fdb159aef7638abecfe8a204f57c01de242ed"
  license "MIT"
  head "https://github.com/sindrel/excalidraw-converter.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "239e08c5dded5806cf0d566afeff81f5ce9d9f47b6b26aa00b64cba2f8962306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "239e08c5dded5806cf0d566afeff81f5ce9d9f47b6b26aa00b64cba2f8962306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "239e08c5dded5806cf0d566afeff81f5ce9d9f47b6b26aa00b64cba2f8962306"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff6a85a94f869ea38d513a0ce49707fd012508a02058f12546d9619cdd40fdf6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "180f5a6657c05ca5bfa0bc06a931799d65ecbdceed4f48b7bbff29e8371a69bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44cfe32ef09fdbd1474b857667bb398042a74318a70d88ff1ecc626e5632e26b"
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
