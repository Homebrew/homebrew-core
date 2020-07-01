class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
    :tag      => "v0.5.1",
    :revision => "d7c0b2e9131faabb2b09dd804a35ee03822f8447"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9009147f0817116c801357d6d8bc082d1f320971a81b7c00051e0d43c8066a60" => :catalina
    sha256 "c475da0533c8bc809525e65a99410bcd39a8a4331216537e55a5c55a8599ebfe" => :mojave
    sha256 "152fe875fe64835efb1e13d088b7e2ca6cf2aa826333465047e8c90bb91e0dc7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # project = "github.com/kubernetes-sigs/aws-iam-authenticator"
    revision = Utils.safe_popen_read("git", "rev-parse", "HEAD").strip
    version = Utils.safe_popen_read("git describe --tags").strip
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
