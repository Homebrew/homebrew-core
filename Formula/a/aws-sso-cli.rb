class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v2.0.3.tar.gz"
  sha256 "7ebb5d64260ac43d9f70c5f9ef2d04567006df4458dd94a27cb53178956c2eb3"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eea421dbbe3524c366b98590ed2984f0adbed717ff2078042786e04cfe78b7d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "624ad5cfc367441ae2eebda85aa63180d74d2351481ada1b2e89a76edb62cc37"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "34f9dc776a3f8a2922a32851555e0c91dc5b61fb02c6199b6950b37c692794cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "a08b9ce059ae0993c9ee9d287a690397b4dee77a9a388cbc4da8e4f88455752c"
    sha256 cellar: :any_skip_relocation, ventura:       "623c98e74ab33aab440d6cf773ea58b49fc5db39d242a3aa000563fa2e8a743a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "baf1985f646b6882b97edecdff708060997ad382612c287888cff78de36e513e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.Buildinfos=#{time.iso8601}
      -X main.Tag=#{version}
      -X main.CommitID=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"aws-sso"), "./cmd/aws-sso"
  end

  test do
    assert_match "AWS SSO CLI Version #{version}", shell_output("#{bin}/aws-sso version")
    assert_match "no AWS SSO providers have been configured",
        shell_output("#{bin}/aws-sso --config /dev/null 2>&1", 1)
  end
end
