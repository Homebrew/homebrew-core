class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.6.tar.gz"
  sha256 "fb614f97f816a7517f94d46a4a3eca74459f12db22245a0a96e3325aa1f3308a"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c359067b64ff126a1d8b136f6f348d53857c42e3570c972be87e5cd08b155af9"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c359067b64ff126a1d8b136f6f348d53857c42e3570c972be87e5cd08b155af9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c359067b64ff126a1d8b136f6f348d53857c42e3570c972be87e5cd08b155af9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "383615d46ec13498b0732dd513b412121983bbd677ecc565740c3b1a3b4598d3"
    sha256 cellar: :any,                 x86_64_linux:      "6c999d303372298ae485fff5c56d4b2e0bf4f196f44e98652a68da4f68f33715"
  end

  depends_on "go" => [:build, :test]

  # `test do` block installs a CLI package from GitHub
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    tags = %w[
      noautoupgrade
      nofirstrun
    ]
    system "go", "build", *std_go_args(tags:), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
