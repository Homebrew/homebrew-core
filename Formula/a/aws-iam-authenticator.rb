class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.6.29.tar.gz"
  sha256 "65355891c3176fd2f4508a742dbb97302984ddf8995e32c41049141da6a498f5"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ab87d86a03aec04f1b9754d7853a83f5281185bc21619785a97063a39b47f3f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab87d86a03aec04f1b9754d7853a83f5281185bc21619785a97063a39b47f3f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ab87d86a03aec04f1b9754d7853a83f5281185bc21619785a97063a39b47f3f2"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e143b3e6967a9e729453b2c8a22d3fe40ec0bed9754e818ccfc4c619d667f59"
    sha256 cellar: :any_skip_relocation, ventura:       "2e143b3e6967a9e729453b2c8a22d3fe40ec0bed9754e818ccfc4c619d667f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0db3141bcf0b962c6e56814bc9890e54866c598a826be3ca160c6562985f7136"
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
