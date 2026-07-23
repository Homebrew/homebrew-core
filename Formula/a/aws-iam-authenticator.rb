class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.18.tar.gz"
  sha256 "06678ff8de3b166275e53e75958e739902dace506342abb3b62f01c00b4aa9d0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2b289775ef93b9d8bceb51fe758543845fdc4906bfc78b0dda1a40da9819465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6eba3592e85a6d2b0aab902788e8552f58ea2f414b24fd14dad20d593653c36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2488003178e683ca7836affacdf036863534f5219d871177efb2ade5536e6597"
    sha256 cellar: :any_skip_relocation, sonoma:        "68b044ad214ea804c45e891ae7dce8db44380f835ed4b87f81756735893b26e2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e8b9f84360e44f4e5f179a98875c022baba3f61ac8e666ee00320dd6be8ad5a"
    sha256 cellar: :any,                 x86_64_linux:  "d0c275cffb0fe03b7db92a5fc3ecc6f04b2a3f15507ce2de4a6fe36129aa0706"
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
