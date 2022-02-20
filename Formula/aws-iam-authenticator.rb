class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.5",
      revision: "85e50980d9d916ae95882176c18f14ae145f916f"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f80d0cacb1853ec245603fcd5cb463998d47b9ec3cd2148f6a6f72a41e7fd57e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c61072867549580d21fb692762ae52aea9bd9d3b476d4be6b99e5fb741347c9"
    sha256 cellar: :any_skip_relocation, monterey:       "b4b7f41452eab334fd6be0cf72c03fe1a53ea4fbf454c16e220ca8b48b5d455c"
    sha256 cellar: :any_skip_relocation, big_sur:        "1651ee0001afe827277bf44ca0fbbe24a7a130d49406452bbfacfd5e10b65219"
    sha256 cellar: :any_skip_relocation, catalina:       "2d1feaeff78a4915d4611f6c7a6bc5228ecb40b110b93ea477b655abef2eb408"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd8b756123e8990593fdbb7659ef529e34411170eccad6fca74bf2a0b2338e4"
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
