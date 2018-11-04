class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/v0.3.0.tar.gz"
  sha256 "91e801c1b1c097f663ebd75897cd5ea19e709bc5ab806e1169ffc508c5a79271"
  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/kubernetes-sigs/aws-iam-authenticator").install buildpath.children

    # this works around an upstream bug
    # already fixed, not yet released
    # see https://github.com/kubernetes-sigs/aws-iam-authenticator/commit/678cdff0f43d3ae4a1d9d68a5347042f14a168a8
    mkdir buildpath/"src/github.com/heptio"
    ln_s buildpath/"src/github.com/kubernetes-sigs/aws-iam-authenticator", buildpath/"src/github.com/heptio/authenticator"

    cd "src/github.com/kubernetes-sigs/aws-iam-authenticator" do
      system "dep", "ensure", "-vendor-only"
      cd "cmd/heptio-authenticator-aws" do
        system "go", "build", "-o", "aws-iam-authenticator"
        bin.install "aws-iam-authenticator"
      end
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "heptio-authenticator-aws.kubeconfig"].each do |created|
      assert_include contents, created
    end
  end
end
