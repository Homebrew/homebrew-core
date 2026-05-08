class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.15.tar.gz"
  sha256 "303a03d077d1469b0eefbb359dec24d65ba2de95913b63b49a18a851027ace24"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d2dd3992eee4d9fc33ff8ff3568b600b1beb40f15bea490f70a4edaffa041905"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a391a726a6b7d50b8d2fd68b55b67368f411560d8754477602e6781ffd881331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "197deedb6e3ad24d5e7f490e3d2d5a0abe60bda6b6b6e9ae05be95d212301346"
    sha256 cellar: :any_skip_relocation, sonoma:        "f41cc1273e2a5e7a0e0d57f5bb7e446997f8772c005f627f3677e3db98ffeef3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d2dfecf62526d1df09fc5bb4543f7d60dc801e7ddc85bbfdda52aef89cb4f53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fb28d3614047b844378db5737a97959a507855f9da8638667442f96ed7da02a"
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
