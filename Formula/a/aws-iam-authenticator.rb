class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.19.tar.gz"
  sha256 "82d69cd6ae7910d376e345f7c7dfdce2289a2534a495334623c7de0a86578177"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34f6e9cc8db1e84911cf345c34e02d521b1d50ccb9f82a1261434a3da8fa12a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4fb5c43050b3fbcdbe5c25d2248b0668fa0bbc521a51d7147c5fd4eeecaaca97"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b119226cc8a1fd038c90e23cacaee0ecbbf03f811da31a3b3a2b1fa5b9bf8d6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "87745662cd840addf30f0b00548e60b53551936c0743decbba7d6f5b96c9a027"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1237c61173566c1b70e7c76c26e6e9fb2e37bfef6098c3eb5bc13981c94691cc"
    sha256 cellar: :any,                 x86_64_linux:  "4a93b6a0e5f8b1df4eba4a8e7e39b29eeee85c691abd4b421fb535eba7e7fe2c"
  end

  depends_on "go" => :build

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
