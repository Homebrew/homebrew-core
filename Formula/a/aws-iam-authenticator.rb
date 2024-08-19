class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.6.23.tar.gz"
  sha256 "a6b10788b10a9ab5cfb2163f0d98850987585b58ed9638e22f1b1b2ebfadd2ed"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "74c72a6ebb1adf7928b356502b041d0b018881a273d0759ff88fb6a25721adb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "06461c7192d57f49e28931ff018597086458489d125834917575055d0951f19f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3016a9ffd3a96210139951420db726500ac8e8fcd215eb43f558d99eb266fd9"
    sha256 cellar: :any_skip_relocation, sonoma:         "6518541d28af948319c7e27675d112ff632c7ee6f9d58b2258c30bf1dc4d8862"
    sha256 cellar: :any_skip_relocation, ventura:        "ce07a1c83f86913af35f40d854b2a7fa7705f3b6164720296e668b4bcc5fbd78"
    sha256 cellar: :any_skip_relocation, monterey:       "5ba895d0772a06ac818003d9fc9ff0294355f9493dde017f5919816a9473905c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282715adc4b8bbc7a5c8c38adf140fc27e7493d07d90d782faf5fc2314d57d7d"
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
