class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.6.27.tar.gz"
  sha256 "86af19ee071736bd9f58d2f2ffdb6b0cc1f1c0b565e90d6e16435deb71871e9a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2d6576911249d810960e1846953a103b06afd33deea65d323d3bc814b834f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2d6576911249d810960e1846953a103b06afd33deea65d323d3bc814b834f51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2d6576911249d810960e1846953a103b06afd33deea65d323d3bc814b834f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4fe9d8a754f05f6383ce8dbc9a7b20e21dc1e5f9a996fd90e119c716432c26d"
    sha256 cellar: :any_skip_relocation, ventura:       "e4fe9d8a754f05f6383ce8dbc9a7b20e21dc1e5f9a996fd90e119c716432c26d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ebcc9928b06971965f9efaec89a91d678a356528c80f0e2b04fcd5b921b44e8"
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
