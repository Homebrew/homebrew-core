class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.11",
      revision: "918bfc9fb357618410d0a6d31b53c757840bd69e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f1cdc24ea147d9999eb8ee4b512aebc6fb88418fbd8c178f8d75a3f9c365236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db8e2d5edcd576621f1def301c8e44b1fc3079e62971e3106cbd39b663e78ab5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "964f5f0e300d92b02a399af97f25693b0bd1282ed9666df597a5145757ba02d7"
    sha256 cellar: :any_skip_relocation, monterey:       "12457ca379a8f5d23831d2e9eef101d9620bb4d1920c445f3a0877cb7ec31ce7"
    sha256 cellar: :any_skip_relocation, big_sur:        "42165f2d6683958368681dc54cbd28e72656f091593ef8165e8e869aefd571ed"
    sha256 cellar: :any_skip_relocation, catalina:       "c3024cc8618032a7151833206a148af182c4f6a56d2d6ce93c1a3ef04b2a9b46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fcacf958bae7efbd904a2f40aa51c615a83a6319cc0d2f7dffaa77bfe63199e"
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end
