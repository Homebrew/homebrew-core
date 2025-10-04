class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "d1d4c929412698fbe63287bd95aabce8c16634349d04613f3f8238e73efebc2c"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "40a3b458f803ea858c05753808acf464a7d8632c5d20e0f96638be25ab63f5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30b00798e3db33efc9b42ba48699c0d8e02b55b36c2865c300494aba78d0c67f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "102c406bfeb5e1f6366fa178913c2b8e9b8320babade82a544c616567a9db82d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d9735769b97d46db97322e28191afb4b3ba8e5b7154a7861f5e65a39bba5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e69bc2c2f729cc788cc0a3763c0d50e61996df086c501589c4c33bf88b13e8d7"
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
