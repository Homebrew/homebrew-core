class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "d8702fbb8dafa327180247d919bedf2187d9becf997be249242c3787165e41ac"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f97f5f8295b6aeb809e16b4a163a4895d8e88dd9415063f3cbe1b7905173ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42bf0e84bc4085b2692ba9814b01194f4ccc0dc5a11454dcb0998ec898fe68c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7d7dd816d4377ef8d4aea9f43ddef237d2b488ac9b1dfa9be83110bf3add89d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "109a530e6b764ea7ab742be93b0e7710d0376036cbeaf8128d1a275c0565c7bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "bb05957eb35fa54f2ea0b6f36a80f5eb59bc4967d4dcc306d1181066dd43ef47"
    sha256 cellar: :any_skip_relocation, ventura:       "0e33f931a25e4c9a42bcf1186c0811e200b3ec6e6feab60d063dbd11a4e95628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b197d0a797cc28030ba9e999df243ba4ef10238b673b279215a91236276a35bc"
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
