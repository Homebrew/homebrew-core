class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.12/gbox-v0.1.12.tar.gz"
  sha256 "66c1d3bb4b6772a06a54b4e071f78522a2b329880378a5df8ed1f8bdb5139727"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5a268325bf77251c4e32f17a065803336fbe55496f203089149f9a20b978715"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16cd9e6f00804fde96ffbbbea5e0d71aaad00a090e5431357fcd718490ebcfb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d9c418d5448c7328eacb03c307c287b59edc672c58567b76a7e23dc8a7364a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "297f7e36484e46d821891144f7f3ae8bd7478197622e9cb25e37e8c3a6985b5b"
    sha256 cellar: :any_skip_relocation, ventura:       "59c1e97c129204fec935fd84e1806492131fc9b17d9d8681e0ad4de38be63bc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4a3d999714d55a3c6b5275d7062b2fd19cb96e21ef1e8317dfbaeab9694e2d"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq"

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", "completion")
  end

  test do
    # Test gbox version
    assert_match version.to_s, shell_output("#{bin}/gbox --version")

    # gbox validates the API key when adding a profile
    add_output = shell_output("#{bin}/gbox profile add -k xxx 2>&1", 1)
    assert_match "Error: failed to validate API key", add_output

    assert_match "mcpServers", shell_output("#{bin}/gbox mcp export")
  end
end
