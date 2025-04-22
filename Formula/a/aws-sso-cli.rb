class AwsSsoCli < Formula
  desc "Securely manage AWS API credentials using AWS SSO"
  homepage "https://synfinatic.github.io/aws-sso-cli/"
  url "https://github.com/synfinatic/aws-sso-cli/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "60e1c76b652f8c005f45e1755a6ecf16772f05e43a11f7ad26d27aef762c28b6"
  license "GPL-3.0-only"
  head "https://github.com/synfinatic/aws-sso-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4d361605d74a8ec19f5a983a00f636f3a55dbfd2eda3bdbe7a787191f2794b93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "914ff263326925c0aeffa103d0429f0ca536952a0eb2cb67df10fb8754ee8238"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f1a770539479dda48289f4bb66e3256dba65d7ee94e49c8121b60e3536b1bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "298cdc26302183335e4c7469c7360d352b445484db107c5e378b04e36ac8dd18"
    sha256 cellar: :any_skip_relocation, sonoma:         "d908014d68ce36bd8867a0101f9100fad7548072fc31c70b8c50caf89bca18fc"
    sha256 cellar: :any_skip_relocation, ventura:        "8066124dd646b5d629165a30ea6cdce65a8603d20e1a45ce207c7007e82f4f33"
    sha256 cellar: :any_skip_relocation, monterey:       "cc472c92adc84d883059d20463dfc5fd82874f1fb13808f6dbb63398893d4722"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d801f3502f41111b88cb851ac284ec9151757a4cce6cbbd347b2eee802d91f00"
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
