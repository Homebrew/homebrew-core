class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.18",
      revision: "6d14bddaf6974d280e227982d2be5ac77a4b3d24"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea8c94a9a0898df4265ce13cd41b1560a61516acb19d65f6f1ff35b26a9790e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea8c94a9a0898df4265ce13cd41b1560a61516acb19d65f6f1ff35b26a9790e5"
    sha256 cellar: :any_skip_relocation, monterey:       "2e15e38926251b15e69494bb4565fdf606151acbff71b8d8b7407bc3fce2a75a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e15e38926251b15e69494bb4565fdf606151acbff71b8d8b7407bc3fce2a75a"
    sha256 cellar: :any_skip_relocation, catalina:       "2e15e38926251b15e69494bb4565fdf606151acbff71b8d8b7407bc3fce2a75a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90dbfb1abebc917e8c7cbfd203a7adbbc1d9546851f3c9e3153c90da6a079f2"
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
