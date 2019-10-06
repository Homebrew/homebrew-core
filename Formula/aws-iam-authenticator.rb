class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/v0.4.0.tar.gz"
  sha256 "d077ce973e5917fab7cbad46bc2d19264e8d0ae23321afd97b1bc481075a31fa"
  bottle do
    cellar :any_skip_relocation
    sha256 "f6ead03c19e3c8c2f6b37020499e3cce3c8e806cfe895314c5749d68cdbfd1ff" => :catalina
    sha256 "524c545b1b500aa81a578371f59c487a31f6b20463731051cc5f3e30551b8b63" => :mojave
    sha256 "7c773fefb0506db8b95ed918ff639ede96b58a4d0d2a51d2faf941f30a61ad84" => :high_sierra
    sha256 "d333ce7bf5e32215161a5f8ba82e86c47a425c9782d8281ab36d66a4bb7cd6f0" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/kubernetes-sigs/aws-iam-authenticator").install buildpath.children

    cd "src/github.com/kubernetes-sigs/aws-iam-authenticator" do
      system "dep", "ensure", "-vendor-only"
      cd "cmd/aws-iam-authenticator" do
        system "go", "build", "-o", "aws-iam-authenticator"
        bin.install "aws-iam-authenticator"
      end
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_include contents, created
    end
  end
end
