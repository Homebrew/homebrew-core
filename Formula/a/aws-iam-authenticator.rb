class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.6.14",
      revision: "b978afae7be72c6c27f8ed2000685b1e9268cd0e"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4d5b7237d7a5c16f67ab0b520915f46a706d127e93e5a60b0917ed129ad1aee9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d30e32e703f51faa65c807f2f0abde845c3e623a2f9940aa6dcb8ffd7e38dde5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a46489d597776b9c4c56e7691aa82188ec7d6c47785614c6987edaf2ac916f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1c2089ace42cacb4bc48abf6c0fa4b4a8bb708e11e88260b7d9ada7bd86fd19"
    sha256 cellar: :any_skip_relocation, ventura:        "ee0e3650554c2ec34bc5b3678241bf25b192f7c591c10450a849a09846e77b7a"
    sha256 cellar: :any_skip_relocation, monterey:       "ed069d5616f9c80b85a5629246f33792662440077e2bbcb283dc4f939bfacbde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "449f840bb69f28c2e1775ed90cea32aaf1c368c823ae2f2233c1f80a8cf866fb"
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
