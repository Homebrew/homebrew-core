class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.3",
      revision: "a0516fb9ace571024263424f1770e6d861e65d09"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0374175f7d0a1965de553e0a4d990d92690d5984c9f1fd0275384f58cd1ec921"
    sha256 cellar: :any_skip_relocation, big_sur:       "50e376c205f257a76486f4ca4da86e6eaaf48231970f13be2039727a9c7e3e31"
    sha256 cellar: :any_skip_relocation, catalina:      "99c0b3d4f1987306f04553d0d8f234d1d105131c844d14c2197b8aa21602f6a1"
    sha256 cellar: :any_skip_relocation, mojave:        "5c722bc544bfaa0d51c903aabe81e1beb4c4f607c5559340fc6a3b2aecc8d5f2"
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags: ldflags.join(" ")), "./cmd/aws-iam-authenticator"
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
