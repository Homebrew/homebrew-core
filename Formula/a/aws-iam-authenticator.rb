class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.11.tar.gz"
  sha256 "1869fd23eb19e8276ee6a4d4bdf1334cf82c7baee849eab7a9f85519d4318221"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "373c5d52edc30e3c858f0d3d8b701253271b48419cd7dc4f77144a9a3454ff34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e8e470826355d369b79143ffdd011a5dd338fca39a9dea5cdd8fa4f2a83ff84"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5eabd2855c5d7863fc7e7a2112b3d791fd4bdaf5b7538a58fcb99a5929a8f181"
    sha256 cellar: :any_skip_relocation, sonoma:        "49d4a8578a6ec185a5eade55c3802895afd35641119798453a1f6b3a919310ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0369060657b37e3f9575c1e55e63aace69fd45c7245aa8493c42ba6b400aade5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d19f848d8583504479ac10ed877e7774c872a1b692ac4b598807b953b6dc2e41"
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
