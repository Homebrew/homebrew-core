class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
    tag:      "v0.5.1",
    revision: "d7c0b2e9131faabb2b09dd804a35ee03822f8447"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "82bd2279cb53c5343d73da2db1ec715b991f805bf67e76bbb2c2958a926f17a5" => :catalina
    sha256 "c754eb2b9da4ec648a9f3d33a480387438d4216fd191118ee932222087fc0198" => :mojave
    sha256 "16400cd25292b76959d9636b34afaf15d3c3e71ad21ae1409a110925efc6d058" => :high_sierra
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
