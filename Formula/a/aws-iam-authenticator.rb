class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.6.11",
      revision: "08f0ebc973028f5b77c9a5f05c452b99664cb280"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c57aeb4520baaa087d34aef9785944ffaad5fa2c4cce8593869d905225d751c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c57aeb4520baaa087d34aef9785944ffaad5fa2c4cce8593869d905225d751c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c57aeb4520baaa087d34aef9785944ffaad5fa2c4cce8593869d905225d751c1"
    sha256 cellar: :any_skip_relocation, ventura:        "7051bab2ea6417f2c9d12c5ff83ae6b8ad4fefc182b31b5ec4777db7419602b2"
    sha256 cellar: :any_skip_relocation, monterey:       "7051bab2ea6417f2c9d12c5ff83ae6b8ad4fefc182b31b5ec4777db7419602b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7051bab2ea6417f2c9d12c5ff83ae6b8ad4fefc182b31b5ec4777db7419602b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd8781bebcb0400179428478e66576190fdd133be73ff319c22828cc085c43a3"
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
