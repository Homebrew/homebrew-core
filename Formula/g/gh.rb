class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.44.1.tar.gz"
  sha256 "6254bbfbca8964e1f0f6631724e9c5f027637df0b4cd0998c4bdfec4554067e2"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3de46753db9a69868ac15f4cc275d90d63d3188309f05df7a92c4cd9c107681"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2de1e75a001dc6223e42dd0f46ef8550f3fb2052c141c76fcaf95886fed0326"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e12990c98f5ff6aaa220587df1a26de07a98bb01a2f989fca3fb53328a60468"
    sha256 cellar: :any_skip_relocation, sonoma:         "a033310b6fd9f02d87ec20968f5cd3271d1f24aab61b71fd8edcdc75217a7d51"
    sha256 cellar: :any_skip_relocation, ventura:        "5be6e4a7c0cb2bcb8840745fec0f0ebb50c89bd83869320b3034c5a4b0528d3f"
    sha256 cellar: :any_skip_relocation, monterey:       "099ae805f2f7879a14c8d50796b2fb067d74548c05f3bb3fdb06b70eabfa76c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "618ecb9300243bdad4cd910c9619e2513d4acc271ceee5835e418e1d4ea6138a"
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
