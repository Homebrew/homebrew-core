class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.6.31.tar.gz"
  sha256 "9448efd07befa1573819da8429e7ac53321f297ff18f592817e07f95259bc394"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  # Upstream has marked a version as "pre-release" in the past, so we check
  # GitHub releases instead of Git tags. Upstream also doesn't always mark the
  # highest version as the "Latest" release, so we have to use the
  # `GithubReleases` strategy (instead of `GithubLatest`) for now.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7bba540c71d44c92cb830ca5f87e5e2c361f961b88dc887743188c8f0131acd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7bba540c71d44c92cb830ca5f87e5e2c361f961b88dc887743188c8f0131acd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7bba540c71d44c92cb830ca5f87e5e2c361f961b88dc887743188c8f0131acd"
    sha256 cellar: :any_skip_relocation, sonoma:        "458fee212f9b23e6475634772c1d4b8071e1bd93f448226e1c45912203c0b7e3"
    sha256 cellar: :any_skip_relocation, ventura:       "458fee212f9b23e6475634772c1d4b8071e1bd93f448226e1c45912203c0b7e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f7781fb23f9a0ec307081f952113776a5ce6d4c97e6a535d2ee16040ff9da54"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}
      -X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{tap.user}
      -buildid=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/aws-iam-authenticator"
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system bin/"aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end
