class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "6be693e219de64db593d96dd0f42db0940ddb1ebfb2b289b2f07215f33360d66"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70ea63e77b5ed06c007d944fb266f502a8cd965cc2c1c560b145ef6106bdee20"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "195ffcafa2b4271d800d0e5174348808febe5e0444d36a0ff764c4d36bc332d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2d0203aeaa13849a36d73c3563efeb52399402e12a3fd4fd53187cdbda93278d"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d2ce9899159f308d0f1fbd3864dced5c9af2e3d0ccfa4d1d8e44b7f1cf4e890"
    sha256 cellar: :any_skip_relocation, ventura:       "9f76869fd8416254e40c8e4cca0a112d6332921b9eece446f6b9f7fde94f00ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e36ddf678067611a030fa642d63e00c449764421ba9eeb831ef244419c604993"
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
