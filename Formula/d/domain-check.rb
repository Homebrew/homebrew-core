class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "175e738e72042bd6d6175f7a29b3ca69fca382560f98fd6a6429409d5a86a811"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c3141987f2defe531925977d9c04542513c88f8afb227cf711fd4625f7e29b88"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c21f777d0a5bb22c766e927c047ea45bd98329ed149982027070505d00ca289b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac1a0e5fa22dc5bbb29b1014d8f0375058e150f270089d157185e5a5c4ad4d16"
    sha256 cellar: :any,                 arm64_linux:       "3816ad65c085a2c9577af0a42cf86855838550104a84152e4b1e092e4fb181bd"
    sha256 cellar: :any,                 x86_64_linux:      "4b46bbc27a845659cb95baebd4b7e4c2741d73377c89493f96b7e36368cee1ea"
  end

  depends_on "rust" => :build

  allow_network_access! :test

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "domain-check")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/domain-check --version")

    output = shell_output("#{bin}/domain-check example.com")
    assert_match "example.com TAKEN", output

    output = shell_output("#{bin}/domain-check invalid_domain 2>&1", 1)
    assert_match "Error: No valid domains found to check", output
  end
end
