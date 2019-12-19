class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
    :tag      => "v0.4.0",
    :revision => "c141eda34ad1b6b4d71056810951801348f8c367"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "52d34b15b5e660a07adca612c6184b83f504fe46232ec053241ab275535045d5" => :catalina
    sha256 "9f81530c6fe28dc4baf6775a2e454fab32103461154ce35d796f2da237ad48a0" => :mojave
    sha256 "3f6e13d4e9d4ae52b38083b34b811e3d863e6defd2faeba80993da32646f1b69" => :high_sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    revision = Utils.popen_read("git", "rev-parse", "HEAD").strip
    version = Utils.popen_read("git describe --tags").strip

    (buildpath/"src/github.com/kubernetes-sigs/aws-iam-authenticator").install buildpath.children

    cd "src/github.com/kubernetes-sigs/aws-iam-authenticator" do
      system "dep", "ensure", "-vendor-only"
      cd "cmd/aws-iam-authenticator" do
        system "go", "build", "-o", "aws-iam-authenticator",
          "-ldflags", "-s -w -X main.version=#{version} -X main.commit=#{revision}"
        bin.install "aws-iam-authenticator"
      end
      prefix.install_metafiles
    end
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
