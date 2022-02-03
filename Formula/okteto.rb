class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.3.tar.gz"
  sha256 "e7165498e79749d07744f0f7c2774b2f165a5f2a0332aa192a44b1deaaefff47"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04275616f2aacc3ab06c366f4b41d2a057323aacab85f64dd0e4c95116f7dd2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae9573795d568252559cb2eec42d53325c32fb12fe600f0e79cb193225419a2"
    sha256 cellar: :any_skip_relocation, monterey:       "d11010b3f97a5ecdb04d4b43aa737f68e5f6ff57243ef4885841a9b2c70fd4fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "21768e7562d93cc274495e67f5b80fe776df3e77a17760fe0846b1cad868e63d"
    sha256 cellar: :any_skip_relocation, catalina:       "92d1baf269c52ae2df06d8458a41e1b92b656d75457648606d2bb8990c4ec1e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "812cbadf3ced98e9b1a825129a388836f87db67180f89dac218877b085f56a60"
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
