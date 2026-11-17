class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://github.com/kovetskiy/mark/archive/refs/tags/v17.3.0.tar.gz"
  sha256 "5b6b1e75b393341dac3a699d83f534cd43b3e3398e8741d434ac3db1ab4146dd"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9e27487458be54422a02b8f3035698e6a00ad944766ed66c50aa79953bfcaadd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e27487458be54422a02b8f3035698e6a00ad944766ed66c50aa79953bfcaadd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9e27487458be54422a02b8f3035698e6a00ad944766ed66c50aa79953bfcaadd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "066c4c59cb41bc5afd536fcffa2a60b42cc382f41c5e46fb6e8cae8e10465e10"
    sha256 cellar: :any,                 x86_64_linux:      "be11e56ae199102beaa46bfbd60982139ea2f1d87da7e63ae6c1a365329d4c69"
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
