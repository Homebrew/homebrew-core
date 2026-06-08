class AwsIamAuthenticator < Formula
  desc "Use AWS IAM credentials to authenticate to Kubernetes"
  homepage "https://github.com/kubernetes-sigs/aws-iam-authenticator"
  url "https://github.com/kubernetes-sigs/aws-iam-authenticator/archive/refs/tags/v0.7.17.tar.gz"
  sha256 "a5634f3c822e6fabffaa3b238c56c577d078806ddd14653b4628d9f513012969"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1097e7b3c0ad50f17e6fbc76bd9cf9eec91d67a9a34974efe185e152fcd35a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f25167be771bd07284968383f22d670711d68e98fd4ed27fbc0c82ed36b11c4e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "598861faeeda4a3dbf25667d1d0274449fdcd0b85951b1fffae7c8001e6b8115"
    sha256 cellar: :any_skip_relocation, sonoma:        "c61c6a84c9e58b835b60d3cde16db26c951473161d024b820a02cbdacb8eae96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "63bd67f4d98ff2b11ab8a973dbe2ecb702eb83cb3d4dd7ad11343f573cd1b72d"
    sha256 cellar: :any,                 x86_64_linux:  "286debeb2f2e291d202916fe658b4f905befc6b395fc0d09b93d749adf71f8b0"
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

    generate_completions_from_executable(bin/"aws-iam-authenticator", shell_parameter_format: :cobra)
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
