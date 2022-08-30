class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.32",
      revision: "624e5bb94696f2847c4f10b75e96694e8919acf3"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da7fa63d18da0c17f4bd2b4d1ddef8a1fa6bf9409ad32646db184e2da74a4472"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da7fa63d18da0c17f4bd2b4d1ddef8a1fa6bf9409ad32646db184e2da74a4472"
    sha256 cellar: :any_skip_relocation, monterey:       "0b9a77f9209c943caabd4cbb896a8cd31690d474735998df1a30ce777b7cee19"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b9a77f9209c943caabd4cbb896a8cd31690d474735998df1a30ce777b7cee19"
    sha256 cellar: :any_skip_relocation, catalina:       "0b9a77f9209c943caabd4cbb896a8cd31690d474735998df1a30ce777b7cee19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7386d7a1f88d925e4621e1950e1edbca8361d813f68084eee7d53d185ad0da49"
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
