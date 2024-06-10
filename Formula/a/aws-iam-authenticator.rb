class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator.git",
      tag:      "v0.6.20",
      revision: "774efb85b060370538c2d47576fb3ba3e58b2c38"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f96ec24eb10c862101acbefc2563ac2875384e6b8079d19cd034588b11121210"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe9666edb0e05fc8878fe9a715b27427467da12c59257be4ea7d7e22759efbc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38af7825bc92fe8e5df74fb62591c23d607eba137c81e71b63af83438a14bf43"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8179efeb131800aae64826fc5d2754dca40f1cdc7b5b318cf25ba54904f992f"
    sha256 cellar: :any_skip_relocation, ventura:        "d0fb1622dafc4e30b94d9ee8d17ed432e20e9796bb2700d66609a476a1db2da4"
    sha256 cellar: :any_skip_relocation, monterey:       "c149fd529d8cd0eb59a7b27340f08c11d7e67ca0eeeb765358a20189ed0825d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c4b2f83ae08aa6c1c6bc686bde2cf3070fa5c1a1ced547b467065b07a54b1d"
  end

  depends_on "go" => :build

  def install
    ldflags = ["-s", "-w",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.Version=#{version}",
               "-X sigs.k8s.io/aws-iam-authenticator/pkg.CommitID=#{Utils.git_head}",
               "-buildid=''"]
    system "go", "build", *std_go_args(ldflags:), "./cmd/aws-iam-authenticator"
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
