class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.13.tar.gz"
  sha256 "d0b05287e7cddec75a2951d27bbc40e76e5a6d20755b69842f67c495de024343"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "960f90fbdc27f08eced8d782c746f4debd0851acb48ae9d1ce43f6a50ed42947"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4224c5b1ed01ff40d43f8fa1c1675190fdb52c6aa148c2a6e04d37d1f7758440"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32b180dd8f5fe09c7b20d2180b7d6b72f68c8b7e4db89a710481ba3287a55adf"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b12bee54c6ff5a5b96284c9a5eeb182ae3628d00822b1f0b2697040b3f4482e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b15fd9046ea54d261171fbdf85b6ce656deeca8d0359b37dcabb131a95e96c71"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7bc487c825bb0264409f92057987c849c641e428495ae9b2629e05d4c314a85e"
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
