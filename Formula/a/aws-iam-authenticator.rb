class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "79a29650c75bce98ddf04e93370090d35f42011aa8b30818b742946d6d51838b"
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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dadcf1ac88b07fc3475c16e1922bdcea9f56879dc0085b6c2f7c12a0d8b920d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52c160f4bc24dd7229624dcc3bce4b595a348f3a07ecb141aefb2a3380732170"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c1d8e16791f3bf4c36f91167ada5e8d95744f7a20e7b3d24a596a18eba52d22d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e02d3c25d44d170e96b654ff09a2dad5816aea46ab455e0b67b419a406100fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bd6aa07c64dca80a99e9a5ef5bdc960437a6e75d6005ccda9e8bf3d5225d8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36babf102f31dfc35d5a2bf5a21036b1d85111d13454769d5745985129a70065"
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
