class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.2",
      revision: "292b9b82df69b87af962b92485b254d9f4b10f00"
  license "Apache-2.0"
  revision 1
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "50e376c205f257a76486f4ca4da86e6eaaf48231970f13be2039727a9c7e3e31" => :big_sur
    sha256 "0374175f7d0a1965de553e0a4d990d92690d5984c9f1fd0275384f58cd1ec921" => :arm64_big_sur
    sha256 "99c0b3d4f1987306f04553d0d8f234d1d105131c844d14c2197b8aa21602f6a1" => :catalina
    sha256 "5c722bc544bfaa0d51c903aabe81e1beb4c4f607c5559340fc6a3b2aecc8d5f2" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X main.version=#{version}",
               "-X main.commit=#{Utils.git_head}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"aws-iam-authenticator", "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_include contents, created
    end
  end
end
