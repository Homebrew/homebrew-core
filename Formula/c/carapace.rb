class Carapace < Formula
  desc "Multi-shell multi-command argument completer"
  homepage "https://carapace.sh"
  url "https://github.com/carapace-sh/carapace-bin/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "c479ef19a9d1b5a8579abb2da437afe7fb024ab23d11feadf746ffda0bbc833a"
  license "MIT"
  head "https://github.com/carapace-sh/carapace-bin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "024c1122729d160a78d48424cb4029c9f2aacb6e18f1b4e3bbccad8280931fb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3df068ac997bc0577136a689cac351b8dedc8ff077cfbd81b9c0a0199e95ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1efe2c31e46a942626e1ad0e749c7b8f83efdd25f6d9122e36939ec49fc07896"
    sha256 cellar: :any_skip_relocation, sonoma:        "076c4a0c48cf141e058e77d58439a182d53541bb13cfb5f08adfce369384478d"
    sha256 cellar: :any_skip_relocation, ventura:       "5cdae8d526134be4f108e9f6522ee389b99955a760f9b5d34d3bd8eac214cb78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de27da9188add3580e86b4b8264e18e9c0a39aa965bc9d39f26d0e8634f912d8"
  end

  depends_on "go" => :build

  def install
    system "go", "generate", "./..."
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "-tags", "release", "./cmd/carapace"

    generate_completions_from_executable(bin/"carapace", "_carapace")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/carapace --version 2>&1")

    system bin/"carapace", "--list"
    system bin/"carapace", "--macro", "color.HexColors"
  end
end
