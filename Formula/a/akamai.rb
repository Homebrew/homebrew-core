class Akamai < Formula
  desc "CLI toolkit for working with Akamai's APIs"
  homepage "https://github.com/akamai/cli"
  url "https://github.com/akamai/cli/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "aa51202c2be133d10c9a34e942749c1359f9e6a4ba6f121d37f05c917d0acde7"
  license "Apache-2.0"
  head "https://github.com/akamai/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d72990121793aba11dd3e209799ba18a402a46b8db3febc5a98c182b287f8b69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f697de247788e7e0a5406bc235265048870c13aaf6cef382ba7ddfdc9757af77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f697de247788e7e0a5406bc235265048870c13aaf6cef382ba7ddfdc9757af77"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f697de247788e7e0a5406bc235265048870c13aaf6cef382ba7ddfdc9757af77"
    sha256 cellar: :any_skip_relocation, sonoma:        "753075c92ea403dad120335559579ce684598a99c16631f3148ee86e32ea428d"
    sha256 cellar: :any_skip_relocation, ventura:       "753075c92ea403dad120335559579ce684598a99c16631f3148ee86e32ea428d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0932738c0a393e5d337308f3508d098c2340b2a6615ed3768a4c949ad6e2920"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fe534c7e4ffdd95743ed89296f80986616f81cbfefd6f03bc7c4958a9240a049"
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
