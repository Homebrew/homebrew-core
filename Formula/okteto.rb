class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.15.6.tar.gz"
  sha256 "af288211a255560a6dc1003287b50006df69ec119399029c4fe52adeb21e1569"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a922943b649688b8543f3ecdcace4db4d6e77cdcc3b2f1d2ea859ce3da980ab2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582f224824d18dc394e2d984e41b0296c14c8027c94934635518b2778bc80a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d02a089fdbc004932f6520ec5e21d2c44c8a16a2c309287910e240b68ccacd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a7a65ce8648e4255b2be83d70f1bff283c6bc2eaad233def4431013483a500c"
    sha256 cellar: :any_skip_relocation, catalina:       "81b39096d62daca1310dd01a9589a7d842986b4a1896fb145bde974d5faff323"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22995fa3ae98d9261b2c98a903626ea111c0f213cea75b67cc70e8d250dfbe1f"
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
