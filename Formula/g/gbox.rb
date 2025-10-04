class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.14/gbox-v0.1.14.tar.gz"
  sha256 "8848ac113b6f53a1efb5a961fb7e2d7de8909317ed319c77508ad3e1e4f40dcc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "86314345710d22eb8237e33c1bf33a73c38c34a8dbfc3e1a0def3e7d1c1a1daa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "210adedf864c938080296ea8b2371f3e0e42b0a6141be475c5926e2676d42c7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d620be4ec6611f426524b032d21df31e7f91fcfced1f87f8ea2f471066c11c29"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f8038dab9612607593132203de716f4b21b0d52ab6136725c2eb22801bc3248"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65c2f9c6c1ab3506e88df951ba0c5195967a7077b6ba809514cbd89e0f719d52"
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
