class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.1.0.tar.gz"
  sha256 "73452f9c0a3d8ac03b3dcf4e8c7df5324f737f2117a122a4fe2b58d3f83f0806"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9e465f387dfd2ae801cfc80b841263bc80077cc7d63de12c8398310b1150831"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b9e465f387dfd2ae801cfc80b841263bc80077cc7d63de12c8398310b1150831"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b9e465f387dfd2ae801cfc80b841263bc80077cc7d63de12c8398310b1150831"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "242b44ff3418247143166d2862ae45f75fb82b35aaf72f6c3d4da742c8d2b908"
    sha256 cellar: :any,                 x86_64_linux:      "a9146dbf1fa6f0c091292a12fb014ad9351f04c3a57cbac700214e409d3a2e36"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml publish 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end
