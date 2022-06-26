class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.4.0.tar.gz"
  sha256 "c24ccd498639f0737851e2c5372cf8ac4824cf926c0b3163445117ba12ab8464"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb36377640e2c328fedbabeac5b584a622effd2412b42912417aa18f28b432bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a29f6ad5581f3be468ecc22f5e309c41581c53e96a3b796291af5c3a4448d20"
    sha256 cellar: :any_skip_relocation, monterey:       "a2f7fb20c8ae6ba8ede57f85b49a8b74bc1efed53954d5b388aa54c06d7e5cf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8cc6beb1e1bca7c47813ec9cf88a65718e48bf22f59b60c576723b251554490"
    sha256 cellar: :any_skip_relocation, catalina:       "08c1ec637e30f28e7791695abb456f51a66884d56d9f114bb32486fa345d6ca8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57b5d6af901776e7443489472e4cc6aa7151839b448ac9c62184f82b9c94161a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    bash_output = Utils.safe_popen_read(bin/"okteto", "completion", "bash")
    (bash_completion/"okteto").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"okteto", "completion", "zsh")
    (zsh_completion/"_okteto").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"okteto", "completion", "fish")
    (fish_completion/"okteto.fish").write fish_output
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "No contexts are available.",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
