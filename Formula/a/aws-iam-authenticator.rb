class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "c78d44bd32a139841f126c45880dda76d689e1b5d9aed6635c0e4f5e2d0fbe47"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe233507f4f9ac3a574c61e4ae1d1c56fbda53411a4c5d844ea7541b58043968"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe233507f4f9ac3a574c61e4ae1d1c56fbda53411a4c5d844ea7541b58043968"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe233507f4f9ac3a574c61e4ae1d1c56fbda53411a4c5d844ea7541b58043968"
    sha256 cellar: :any_skip_relocation, sonoma:        "c88ef45a3a41c165e73558821f59bea2d7a3b0e3a1a2470f89e4c501a35404b6"
    sha256 cellar: :any_skip_relocation, ventura:       "c88ef45a3a41c165e73558821f59bea2d7a3b0e3a1a2470f89e4c501a35404b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "38c3d6b467856aa90af9434a926cd43515ea8c0ceb5266da62b5b75c26cd65c0"
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
