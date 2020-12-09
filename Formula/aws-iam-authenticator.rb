class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.2",
      revision: "292b9b82df69b87af962b92485b254d9f4b10f00"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2a13645e0f747838f9e8956a9b6308311ead2b47098bfa2fd9cba73f39180b00" => :big_sur
    sha256 "d1ff25777bf45e10ac8eede3897bf9f6aeb0982f17e061797392e18bfb5d7aa0" => :catalina
    sha256 "fb86fbafcccfb9a111766514290e969406345e8f7c8f443c54a856131736f07e" => :mojave
    sha256 "17f26f6e145021a386dc82c9fd9f012b81f30cb18c39d6ff98627ea319c5cef3" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # project = "github.com/kubernetes-sigs/aws-iam-authenticator"
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").strip
    version = Utils.safe_popen_read("git", "describe", "--tags").strip
    ldflags = ["-s", "-w",
               "-X main.version=#{version}",
               "-X main.commit=#{revision}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-trimpath",
           "-o", bin/"aws-iam-authenticator", "./cmd/aws-iam-authenticator"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match "\"Version\":\"v#{version}\"", output

    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_include contents, created
    end
  end
end
