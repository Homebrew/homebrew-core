class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.5",
      revision: "7d2f279c59ddf18e62d065001490e4edb263adea"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ede7325cb43e12cdc8885ad28d35861355ab9df670fa4709f0e7fd1ab9648929"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ede7325cb43e12cdc8885ad28d35861355ab9df670fa4709f0e7fd1ab9648929"
    sha256 cellar: :any_skip_relocation, monterey:       "af92d14bc37776aeb3164ac19e3a84869c8a947b325f1f64818e45f38541f4f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "af92d14bc37776aeb3164ac19e3a84869c8a947b325f1f64818e45f38541f4f2"
    sha256 cellar: :any_skip_relocation, catalina:       "af92d14bc37776aeb3164ac19e3a84869c8a947b325f1f64818e45f38541f4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b676f93f90381491b1eba07db5a96f8879fddd73c4697f763f91c8c1b18b281b"
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

    system bin/"dagger", "project", "init"
    assert_predicate testpath/"cue.mod/module.cue", :exist?

    output = shell_output("#{bin}/dagger do test 2>&1", 1)
    assert_match(/(denied while trying to|Cannot) connect to the Docker daemon/, output)
  end
end
