class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.9",
      revision: "1209cfe28e95e32e719d0d69a323e6172a423333"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "707e82d4d95a99dc09155c01fff3cf9f06700801a9f585893960a04e4da897eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12efc857905e148e434b541cc76801956f186ca92fb43ea88884303a1c36c175"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba09e1a04810d7fc4fe0156a231d6a28c507a39cd7579d2f8705c204d1611cde"
    sha256 cellar: :any_skip_relocation, ventura:        "98505c961b95929d73263a456bff7f5cf7a36ccdd1106df3a5880fcebefb70bd"
    sha256 cellar: :any_skip_relocation, monterey:       "091e33fd80229c5db17574795d5e44f9a54951e3fc2df24336c2cd449cd6e839"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd2327738f22d7c95ee22b15915cad3ab850cc439f8684680ffe14c07c221d7f"
    sha256 cellar: :any_skip_relocation, catalina:       "0207f549dce4741625e3a93cad4ddcce8886a18eeb13ddbdf7d27530056877c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0b736f1703281ec4d24052cc3758ea3db9304a2099f272bd6dba12668f771f3"
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
