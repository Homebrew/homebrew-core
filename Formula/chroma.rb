class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "98a517ae99f48e3b54d5c8cd7473d5c544f51bee7a4be17f5175736fce37da56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75e29e27b386effb7315e9e84314d67236354d6c74d3271fab2a224c62e6a986"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2e2087d1ebfdafd9d892b9c8bf82c456e91278455da5bdf72610c7de6109d21"
    sha256 cellar: :any_skip_relocation, monterey:       "50e9db86d4730e8ec01832d12dcae51dbc2301baa695e3d7e82070dcc6ac4563"
    sha256 cellar: :any_skip_relocation, big_sur:        "232eac78b82e2fd539d2e878950b0a3c7333d23dfa8fc8690ad4c074d7d281e0"
    sha256 cellar: :any_skip_relocation, catalina:       "08d56a32ce44c4c989c26f5d0aa8ad22e659c93ba67e3e1810362b69594f2b78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "809c9629dffeceffbfe0618602df4ef20d5f6b3cb27a557b10005533baa069f6"
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
