class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "eb7fd0a42fe85efd220ac40123ea3629ca5e6b32aeaf3318dedfc9b2e66b2974"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ee1be2abdab3e4ce4aca8f0f8db9cd4814a16ed4c4eaf15ad2e6fb43e1fbb2d9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c696697b5d548942d9c7a13e4df38edc20724ac9558f4626eff5ffd5a64f72a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e83fb3cef05e04ee1e6cb76df7a34d26a4b72a7f45e4d00f6eb83dd6181dfc14"
    sha256 cellar: :any,                 arm64_linux:       "7f37c5cbaa7cdcc16fe5b0dcb9b4a0a5f1e11c2a1637717cac640c67e609d387"
    sha256 cellar: :any,                 x86_64_linux:      "c88c0552413b778f00247e08790de5f70f8712c7e5dfdfbb5c12073da536ce4e"
  end

  depends_on "rust" => :build

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
