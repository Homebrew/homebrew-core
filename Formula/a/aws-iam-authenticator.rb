class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.24.tar.gz"
  sha256 "388d274decebfe44dcea09e00bb3d11d97feb9b6f3fed5f069452a9c6df05754"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "75ae15d50b6c4d41d993ff0431aa43a7f4a05b80ec9a11a1fe657f024c60984d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b01e322a4fa25e1c12d3829f3fdac435eb38b56eef2c2cc5ac3e8d9365557295"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "822e7574ca90f40a35574309a1c9721360d5e9d5be7ca0d8e7090bb709d9d608"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "66cb1f11fda974993f28d83af7fc85abc987e7f2696e761e00f965293a5a9a5d"
    sha256 cellar: :any,                 x86_64_linux:      "c2a2d2e9fd6dcfe58c996f8306adda54b89a58d9401c6448060cd2e4cd7acc63"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}
      -X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{tap.user}
      -buildid=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/aws-iam-authenticator"

    generate_completions_from_executable(bin/"aws-iam-authenticator", shell_parameter_format: :cobra)
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
