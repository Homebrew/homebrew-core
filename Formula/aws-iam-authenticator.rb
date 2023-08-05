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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8695863898b3293716a26cc81114eb195ca53d7f826e7e4e671f381b5f9a311"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8695863898b3293716a26cc81114eb195ca53d7f826e7e4e671f381b5f9a311"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8695863898b3293716a26cc81114eb195ca53d7f826e7e4e671f381b5f9a311"
    sha256 cellar: :any_skip_relocation, ventura:        "c25bb70b23f77442369b6ebd5191dee468948f306ac2e57e30b108f87e8b4cf4"
    sha256 cellar: :any_skip_relocation, monterey:       "c25bb70b23f77442369b6ebd5191dee468948f306ac2e57e30b108f87e8b4cf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c25bb70b23f77442369b6ebd5191dee468948f306ac2e57e30b108f87e8b4cf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e3049059c9888e34917ec3b80eb2479745bc48f7937ffa30b8cc8366d988f0c"
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
