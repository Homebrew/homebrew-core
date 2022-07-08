class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.22",
      revision: "33bf2080c974b25f1ad370704b23dca893fdb1ea"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74bf7f2ed67f32ae14b31e79d02da25baf6a77c36db42899a8f8af65ee52d0ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74bf7f2ed67f32ae14b31e79d02da25baf6a77c36db42899a8f8af65ee52d0ad"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a5dfc137b1705737bd3b772b56f4c08514131b21057dd6d800bb704d4982f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9a5dfc137b1705737bd3b772b56f4c08514131b21057dd6d800bb704d4982f5"
    sha256 cellar: :any_skip_relocation, catalina:       "d9a5dfc137b1705737bd3b772b56f4c08514131b21057dd6d800bb704d4982f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c3032da25a13f990ca48499b3fdc5141a396e1a4d1cf262af64245833c69808"
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
