class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.23.tar.gz"
  sha256 "718bda8a0907fe01540733a4b3bf9770b9cd13e6eb2ed8b41cc2aaed6acb8949"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6ee8e0fa1cec0c5e86864354d959d8f4884b3353abdb9a20d9025bce8705ebe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4ff2e4a2cdef577619a78b5a943b0870a213058d3edaa3bf920b577c6d9095b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6305d93b31b7deea9f99976586d985c6b7bfd07e4bc583b74f7d68cd957d396e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f88471789f1500b106f36f54e826d0366d7c0980d342ae5c1f23497d6ef12b56"
    sha256 cellar: :any,                 x86_64_linux:      "7fb049040f6774f41d564b95c96b45100b8c073af46e9f27e9ecc3755bf687a1"
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
