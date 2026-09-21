class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.20.tar.gz"
  sha256 "3e0a6d95d43add722e8a0fb44d6149e99175792c66b3543b9790c6d32e06780c"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54742613c08da7cb42a890536f8e543e97e083ec79b740fd1b749119f368bec8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b893ece9c6cda87b2e3088bd6283e6db784d362927dfed2782218d857797d3d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b5625fbf3bb9585a1d21bf8cd3d5be092f8988deba2d6661516ba546b369f17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b553e85f451d667e68ad5cd2d7f302bbc0f11fe6b7e61de7db3a537c7810cb14"
    sha256 cellar: :any_skip_relocation, sonoma:            "4733bb833f781143eefe015aecf234ced788c616907be416dd46b97031241bcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "caa4a9e900ae0a7fc017be1630068e8b5d3be8dc4e75243df2fe33143bdf1c93"
    sha256 cellar: :any,                 x86_64_linux:      "4625f2eabdbd0db65a9af0018cf06db7c4e52243aafa5f014479e7a5fbe40142"
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
