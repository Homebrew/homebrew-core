class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.6.0.tar.gz"
  sha256 "bcd6062eb7795d4b903ca2b4a7c20be103e03a46362820cb0c3f2e19e9ffa687"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fad20894b203419714ca5f7f0d435a2b766d5025507ab549142a7c71fd0c08c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fad20894b203419714ca5f7f0d435a2b766d5025507ab549142a7c71fd0c08c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fad20894b203419714ca5f7f0d435a2b766d5025507ab549142a7c71fd0c08c2"
    sha256 cellar: :any_skip_relocation, ventura:        "12149bee60597da7c86329b0ac6e7df9ee73f2f5ad2857e736452437f693121a"
    sha256 cellar: :any_skip_relocation, monterey:       "12149bee60597da7c86329b0ac6e7df9ee73f2f5ad2857e736452437f693121a"
    sha256 cellar: :any_skip_relocation, big_sur:        "12149bee60597da7c86329b0ac6e7df9ee73f2f5ad2857e736452437f693121a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8da7f24ab8af374653aa0d2a8ee2c4ea29385909e67a6f3ef13df77c47d8b78"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
