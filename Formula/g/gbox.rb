class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.13/gbox-v0.1.13.tar.gz"
  sha256 "552005eee1351fc57ab4b2244736c4cabe3315b8053d8012b19f4c56aeafdacd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "218971423448f53a21b18e7ce83f5a6876d7351dffebef12720b90adbb8abf13"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c7b1cc8aba50fa69fa822e57486f13f25eba1ba275c55faecf33737d8fdc173"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f472de71655d96108de1769f71a6f2abd9ef5dafe01f0da296812dc84759b45"
    sha256 cellar: :any_skip_relocation, sonoma:        "30a4e76dc5768a2e4e346f1a1c7320aa234300189cd5bc92c5b343ffb407bea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e618f823927a7e652e4c28a037250b1d23e9edd00ddc8582238994c541b7264"
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
