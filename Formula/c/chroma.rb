class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.9.1.tar.gz"
  sha256 "4f58ad5b33d8a8681b085e57303a85cb39158a62349dfb8bd16e780a049d788b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad1931cc3cee5f242388c3439cd8b6635ed7af33c96b6008e3a459197aa60597"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad1931cc3cee5f242388c3439cd8b6635ed7af33c96b6008e3a459197aa60597"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad1931cc3cee5f242388c3439cd8b6635ed7af33c96b6008e3a459197aa60597"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad1931cc3cee5f242388c3439cd8b6635ed7af33c96b6008e3a459197aa60597"
    sha256 cellar: :any_skip_relocation, sonoma:         "9be440f448f1c417a0aa906196baf1b594dd188040ae729b00ac67f20c0c5b3b"
    sha256 cellar: :any_skip_relocation, ventura:        "9be440f448f1c417a0aa906196baf1b594dd188040ae729b00ac67f20c0c5b3b"
    sha256 cellar: :any_skip_relocation, monterey:       "9be440f448f1c417a0aa906196baf1b594dd188040ae729b00ac67f20c0c5b3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9be440f448f1c417a0aa906196baf1b594dd188040ae729b00ac67f20c0c5b3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c8df59e579146e45f46a0e8c6782e9197f591b69074da7e1e776fb25d6ccbfd"
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
