class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
    :tag      => "v0.5.0",
    :revision => "1cfe2a90f68381eacd7b6dcfa2bf689e76eb8b4b"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52d34b15b5e660a07adca612c6184b83f504fe46232ec053241ab275535045d5" => :catalina
    sha256 "9f81530c6fe28dc4baf6775a2e454fab32103461154ce35d796f2da237ad48a0" => :mojave
    sha256 "3f6e13d4e9d4ae52b38083b34b811e3d863e6defd2faeba80993da32646f1b69" => :high_sierra
  end

  depends_on "go" => :build

  def install
    # project = "github.com/kubernetes-sigs/aws-iam-authenticator"
    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip
    version = Utils.popen_read("git describe --tags").strip
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
