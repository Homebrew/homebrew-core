class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.28",
      revision: "41b7d6190bc6d7bde4894d32072e1d62b2a2c89e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d13d2a50d3248353daf262c84b95af55ed031b878b5e60c00f173c5a3f060b0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d13d2a50d3248353daf262c84b95af55ed031b878b5e60c00f173c5a3f060b0f"
    sha256 cellar: :any_skip_relocation, monterey:       "a7166bd9cd937b7d4a1c6cec1bbbb4f47eeeafcf00aeef5d7e55e947cbb80de8"
    sha256 cellar: :any_skip_relocation, big_sur:        "a7166bd9cd937b7d4a1c6cec1bbbb4f47eeeafcf00aeef5d7e55e947cbb80de8"
    sha256 cellar: :any_skip_relocation, catalina:       "a7166bd9cd937b7d4a1c6cec1bbbb4f47eeeafcf00aeef5d7e55e947cbb80de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "488e48a806d4380109ec0bd67c13cb4793723be2f03bde9915d20eae76bf492d"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X go.dagger.io/dagger/version.Revision=#{Utils.git_head(length: 8)}
      -X go.dagger.io/dagger/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/dagger"

    output = Utils.safe_popen_read(bin/"dagger", "completion", "bash")
    (bash_completion/"dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "zsh")
    (zsh_completion/"_dagger").write output

    output = Utils.safe_popen_read(bin/"dagger", "completion", "fish")
    (fish_completion/"dagger.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/dagger version")

    system bin/"dagger", "project", "init", "--template=hello"
    system bin/"dagger", "project", "update"
    assert_predicate testpath/"cue.mod/module.cue", :exist?

    output = shell_output("#{bin}/dagger do hello 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
