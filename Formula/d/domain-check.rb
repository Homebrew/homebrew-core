class DomainCheck < Formula
  desc "CLI tool for checking domain availability using RDAP and WHOIS protocols"
  homepage "https://github.com/saidutt46/domain-check"
  url "https://github.com/saidutt46/domain-check/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "bc6f7f3ccbb83813cf26f3dc937f1e41a96bd147269964fdb5d2469c99285949"
  license "Apache-2.0"
  head "https://github.com/saidutt46/domain-check.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d405580bb98368ff43a8d68f9f955c8644fa3317a656faee3cebed3b06cab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc82352c7e3e20bb7e7ccf76b912262f8f329aa38a9e1ead4c49a208d0f5bfc9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c2644e6cb0a7bf0f098225659eba8c96ba01ead60cfdfee8e3b4428c6c05547"
    sha256 cellar: :any_skip_relocation, sonoma:        "be4c79be238aaef556143b4728b97e0a4f19acbcec8ea998924949491b55427c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1163df7d613d6c18dd5694017e2be6d79ac25d7efff5a63fc26ce0794eb99c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a040535d23071b69cbbb727758505f761dcd8ac6d82207a2665582fbaa3c639"
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
