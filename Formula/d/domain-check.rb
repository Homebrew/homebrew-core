class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "0d105c79c0864ab7dc6eab3ed13e41c53344ce42bf538892123bad38396b2b10"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f2ef536af26f51bc0a144befc8058b9f7d0010b94497531f6dd7dfefc11a128"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd74f3abf89f82e24e671a906c03feb140f565fe430a05dd59a687cac90ed55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "793d840397bbee32d66818418645ba4a8425a82bc5e2818e149bef60d6f32ebb"
    sha256 cellar: :any_skip_relocation, sonoma:        "c394f09e96652a567bf543c73895cc014e5da239efbe657c378415d09634745e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db65a4f14522aa1eab93d6425e37e6e095dc2d283890b8a89d1e91a6e0277f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62fca6dc8ada99cd3b73af944ab931f6481b3dde94f6be361a44380637bf8716"
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
