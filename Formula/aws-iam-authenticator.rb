class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.3",
      revision: "a0516fb9ace571024263424f1770e6d861e65d09"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e82311b2f11745925a8ce73a05c24e38c8122063b6ce070a4610c8d54f5fda76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30639bda3ecb72388aeabc0f3e6587f58bc9867dc6b3a9f3046e9d0ef659f122"
    sha256 cellar: :any_skip_relocation, monterey:       "e3718d03e98702a4893b480a897779e7ae8ca52b39f879d02aa6fbf0a1220f8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a161d4ea3ef00ab85c8f0cea198e0dafde39cd3a76359b75ea22521c35eac7d6"
    sha256 cellar: :any_skip_relocation, catalina:       "192ace97a0c76ed0aceda060290db6abcde5af8ad7dfc30faaf5f4ed4ae92b6a"
    sha256 cellar: :any_skip_relocation, mojave:         "c7f23ccd6bdd852a7c1928df437381204aa9da22a2f41eb3a5776864838f39db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6d0c278ef6d1d19a160035e5ff0039a16121be7107acce9bfa55ab59054c2f4"
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
