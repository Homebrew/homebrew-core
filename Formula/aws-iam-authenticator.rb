class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.5.7",
      revision: "2a9ee95fecab59fab41a0b646a63227d66113434"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1ea442e5f2e2f476ab7e3b8090d26b747fc4c29297204c018242d829a0c9ec5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "150311fcae7892a872ae8da3c736e0206631a32f1820a02fd48d17b741b7f8ca"
    sha256 cellar: :any_skip_relocation, monterey:       "cfd4fa055f8bcf948df948270bfb69a740869aa25b16cb8574ca4c8d208676c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5a8a0217de3f690af033c17326e81ab2955c5bd9e696fae5a1fce00f1f2a915"
    sha256 cellar: :any_skip_relocation, catalina:       "48cdc1062c9af6a88bf473663573c42024f88b635516a7ce30fa17d96cc79a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98db0cba058afbe8736744f3b168b4e346a53211d1199b283ecaa454197eacb9"
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
