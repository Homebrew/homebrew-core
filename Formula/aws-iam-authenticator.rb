class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.6.2",
      revision: "d72e1b46444d0efcb995a28c3846223b39bc4964"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a420cef8c1d162f9f064e1c400ba09fa4607e93d8f3f60c1071f2b6a9904dd6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51dab83eef66e76441997590f9e56c6e63b7e8b7a1495f888319cdc0ba337327"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cf608184586538199b123b0edd898682cd41cb37fd1515059259285a819c0fd"
    sha256 cellar: :any_skip_relocation, ventura:        "803311bd323f8f3cb1a9dc87244379c1015f86384e9d029d0f5eaad7421fee2c"
    sha256 cellar: :any_skip_relocation, monterey:       "aac61dd3e3363ee81e07273c388b21d9da51d41c820791cbb020e842b1e10d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "153361f6924dda3940e9a1852164700274e99d1a99cfc39f81ad0c31de757c7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61018d500dbd08ca3b6a7a9d66dc6d0987bd013072bd041bdfc703e2fcb165cc"
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
