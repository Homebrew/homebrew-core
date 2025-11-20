class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.16/gbox-v0.1.16.tar.gz"
  sha256 "f59cc1df62c2ed77a0bf61d41ab8c85190e3458e527dec47d94ca2bef975fdc5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "54c6f3ef399a960a81e4618e7134988a885c4757045fce4fdd1ba3453f31293b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81a3c1c2f4f15324cdba10c82f4c8ca333bd515239a962d35ff88dd011d9549f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f3b406339e6d08d280938622f7e57d51dd7a8555a20cf1d561dfbefa1556e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8e85690c4c259a8a18a3cfcfb242c8bc9525fac6368b712a09e5cadcd8df6e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "778f2d944130f467850047d3452460dcd2619e350fafb56ea96eeeede75aad27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c191a589088c5272c72358c6d1f2e93f0db9429541e48e108e8295551df2710"
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
