class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.46.0.tar.gz"
  sha256 "663871687310c671ecc183a258fa573622e1e972c681982ac79a25c967fd40b2"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b87b0b97a6e3fe12dcdbf6ad18c9077d8fe5049ea707fa597e2c0b71c0e588"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1aebc503d655fa37c638cb52ebdeed7fd6e8313e07fe0752a49a0db1aac818b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f1ae33dddb23d335b82642422c39ccfdcb48c1fc90482b38b347c813cdfe368"
    sha256 cellar: :any_skip_relocation, sonoma:         "102cee67b38b52e21725d61de9ec95f76b7553b43f0202e3f6a9ffff805d2026"
    sha256 cellar: :any_skip_relocation, ventura:        "4c8ac010cacd718e375d6ec2d5999193f8eb56a9418263476bb85651cf56402e"
    sha256 cellar: :any_skip_relocation, monterey:       "d95023e1e64cf1d2bed3591469acb289b7cad457e160028e31258791be8c4b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9b4aacd9897854c7dbfe8adf08b204616ecda44225b7218455b19de246d8795"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
