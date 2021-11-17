class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.14.6.tar.gz"
  sha256 "077518dcd4d0302ac49b9fd2c8240eb594b2bb7aaf70a91d5c1fa2fdc1ca47ff"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5267c74cf266d075bdea415beabefcf1365510b62e0391da9e1f169b5008dde2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3fb521674c1663d864df910f7ceaae04ccf7fa94cbd2aefcf05d7a138da170bc"
    sha256 cellar: :any_skip_relocation, monterey:       "82101d4cc821d7c02c55fda7c3858069bffc8659520e77b83ac40c9f84f16548"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c91d3bf5da8ff23e9ff83e39223711f227251f989628ee266d0a2df6ebaac6c"
    sha256 cellar: :any_skip_relocation, catalina:       "b9b41afc6f0f050e8a7bc5bffba0dc1ff8bfa22febce4421a6afd9ae66d5fbac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f9b515fd5478f3ce384162a16f3a35abe0d67ee172e49599e2135b1e5f2c741"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
