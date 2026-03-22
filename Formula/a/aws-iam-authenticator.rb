class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.12.tar.gz"
  sha256 "a8edf13b033400ae9bf5c0d354b5aa98ac133d3d781dece4568ae9de5e74eda9"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a28929b04fe8d25b42a78d37a2ce3cb3936d14596b1e3e862abc580c6232a1e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ecf6373985b6ae98bf38393d74119f82856641641e57885ed1206229e7c56d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9407174faf71608e53ce9aa7fcffd3bd827bb915bf1bb130cb4a8e0ea830ac6a"
    sha256 cellar: :any_skip_relocation, sonoma:        "db7180b9fc9d55ebbe58196b0bec91808febb32c4b058d1d57b85641affdb1d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "263c2675226a8686a97016ed9284439501c1b36f10a1f2fb8887f28e4932e565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49fb16e9ccba8634dd545aba3060bc7b70e4fd854e64be3047e2278852e65b9d"
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
