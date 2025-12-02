class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.9.tar.gz"
  sha256 "347e495c1cb5465ceca1325422902569c93a5f67c0cdf152d64a9a9159825de0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac01413cdc4bc18eb6f728453703cf9a82757ab44cec373e9d14f1fdc82e2f29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "424aed0e9c363b683bd2385d2791d54c939b72f5d9df1cafd480f26e10a4f987"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "580fca68db5f759c719d7d366e3b76f30d726b0c619cdd6ec6c0cbbd09e97c50"
    sha256 cellar: :any_skip_relocation, sonoma:        "7891a474606b72188b216bfde29e32a4461d36342221de5faf0acc1131fe991b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6cc3c57ed5dce747e734b7403a7b2c466c2669f6dfbc348c1ec4029e4728e15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db31339d97aa54babe4b9953b1d1b217ca897a8c4319d0bcb8b5dd2731772520"
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
