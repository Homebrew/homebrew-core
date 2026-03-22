class Gbox < Formula
  desc "Provides environments for AI Agents to operate computer and mobile devices"
  homepage "https://gbox.ai"
  url "https://github.com/babelcloud/gbox/releases/download/v0.1.20/gbox-v0.1.20.tar.gz"
  sha256 "d2d8f57c90af6c4cfa468df93e0fc83754b9cb5515b08bdaf2c17d0886a9c581"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a08dd5ac639444c85e52605514c46e4ba05d189d3baf1c6ad7c0e56a0c1c79db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6fb4588a0477e499ee2a2bc6b0c08706b3332baa299fd1905347951ecba7fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39b7df2cee49f23cc8df410168522dc35e7dcbcabfecec33b2dfdbd5820ef92a"
    sha256 cellar: :any_skip_relocation, sonoma:        "16c94addd81ea9d57b8526fb2377cc551010688a5c5f2c7f54689f0f50b1d1ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "568a87354cd176bf21d3373530c91ce2d7f3b5ca13eae1f5434f2e6e0065ff9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41d9e6dc8921c4e5f0a76f31e52ce0da2cc9ecb3562f48a72f3fea7425902f0c"
  end

  depends_on "go" => :build
  depends_on "rsync" => :build
  depends_on "frpc"
  depends_on "yq"

  uses_from_macos "jq", since: :sequoia

  def install
    system "make", "install", "prefix=#{prefix}", "VERSION=#{version}", "COMMIT_ID=#{File.read("COMMIT")}", "BUILD_TIME=#{time.iso8601}"
    generate_completions_from_executable(bin/"gbox", shell_parameter_format: :cobra)
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
