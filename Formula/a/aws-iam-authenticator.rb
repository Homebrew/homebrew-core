class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "74d904d9663ae0e9e6425523ca61daaeacfec748f51845042bf6ce5741d39e98"
  license "Apache-2.0"
  head "https://github.com/kubernetes-sigs/aws-iam-authenticator.git", branch: "master"

  # Upstream has marked a version as "pre-release" in the past, so we check
  # GitHub releases instead of Git tags. Upstream also doesn't always mark the
  # highest version as the "Latest" release, so we have to use the
  # `GithubReleases` strategy (instead of `GithubLatest`) for now.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c07b8347be4514f09dbd1829636268605530c374be5c72a978f08412a3df0aff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "382efb904b41b50a6450223dfb9131526a4391694966cbda1e6e3a9e610e11f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6403e833ec0bd96a7b8cd342513630b0eaa3b5e018a117d6f684cb082840fe3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f2f677731b1124deee088a0d759582a00a5393f323efba8c777c02ae2ef9a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "1b556a9f226a745a5c68df99046c6e3c28008c93194ada6866ab3cd8328fcfee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbf3140993ca68b2d4059a15cc422bc0ca60bc63ff54d5a6541db1c732da43a3"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}
      -X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{tap.user}
      -buildid=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/aws-iam-authenticator"
  end

  test do
    output = shell_output("#{bin}/aws-iam-authenticator version")
    assert_match %Q("Version":"#{version}"), output

    system bin/"aws-iam-authenticator", "init", "-i", "test"
    contents = Dir.entries(".")
    ["cert.pem", "key.pem", "aws-iam-authenticator.kubeconfig"].each do |created|
      assert_includes contents, created
    end
  end
end
