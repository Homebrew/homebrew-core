class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "75859266f9a4f0967bd06f86a6b8d83629fbe549e437a259dfc61c5ad13c7ca6"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fb554e08aa91f7aaec34966c012e58c9a16efe682e51f9259b6665fcfc190b98"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb554e08aa91f7aaec34966c012e58c9a16efe682e51f9259b6665fcfc190b98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fb554e08aa91f7aaec34966c012e58c9a16efe682e51f9259b6665fcfc190b98"
    sha256 cellar: :any_skip_relocation, sonoma:        "e065c36ef1531fd4b8e4ec09796bb3df95df2e3224999d0509f447a1c38a42ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3369b35aa27f90554855999fcf74a54f33004bfdf148983396c912624081cce7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bc4621795165f0218f2381b9df0059f168c94fced7327396e4ae73102b70a2d"
  end

  depends_on "go" => [:build, :test]

  def install
    tags = %w[
      noautoupgrade
      nofirstrun
    ]
    system "go", "build", *std_go_args(ldflags: "-s -w", tags:), "./cli"
  end

  test do
    assert_match "diagnostics", shell_output("#{bin}/akamai install diagnostics")
    system bin/"akamai", "uninstall", "diagnostics"
  end
end
