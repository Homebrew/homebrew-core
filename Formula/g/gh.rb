class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.79.0.tar.gz"
  sha256 "2408f3f5d69ea7efde1f174ee058ca011b8ab24e583178c6f090f3e91767bda4"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdc5f1450eaae1974b45156a284eb59d1ec515f6063ebcbea97c82568f472af4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdc5f1450eaae1974b45156a284eb59d1ec515f6063ebcbea97c82568f472af4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdc5f1450eaae1974b45156a284eb59d1ec515f6063ebcbea97c82568f472af4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bdc5f1450eaae1974b45156a284eb59d1ec515f6063ebcbea97c82568f472af4"
    sha256 cellar: :any_skip_relocation, sonoma:        "022b6d5c84725471a72e43bea5e5a6c8c41d98bb5845a87e1a12c4169943e256"
    sha256 cellar: :any_skip_relocation, ventura:       "6f0fec05f657ffa3bede3fe63d8e93cdb65ca48ca26969a123e40a6a19d2fa4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cea54aab7ded459db336e0de0f764ef2b8b0e7ae93ae6930735cff447922a50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e12df8b39b66e88fcf2b9cfd23d5bcfb816f1eb374a3c9182f11e0aa5b2bfce"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    ldflags = %w[-s -w]

    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    with_env(
      "GH_VERSION"   => gh_version,
      "GO_LDFLAGS"   => ldflags.join(" "),
      "GO_BUILDTAGS" => "updateable",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install buildpath.glob("share/man/man1/gh*.1")
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
