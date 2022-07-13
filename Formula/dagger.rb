class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.23",
      revision: "2927c77876a83c0aa688ba648fc376f31eccf5bf"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3e6d2c3aaa975e88aece0949482342967314f3defd2ae1b730dbfaefc293298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3e6d2c3aaa975e88aece0949482342967314f3defd2ae1b730dbfaefc293298"
    sha256 cellar: :any_skip_relocation, monterey:       "f13534f77ddf830506a50b1df35bd40630d93e718e4658d8574a0d1225060d11"
    sha256 cellar: :any_skip_relocation, big_sur:        "f13534f77ddf830506a50b1df35bd40630d93e718e4658d8574a0d1225060d11"
    sha256 cellar: :any_skip_relocation, catalina:       "f13534f77ddf830506a50b1df35bd40630d93e718e4658d8574a0d1225060d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53d975ea1886168363a38786810426918ed6aad1720609eb418f642061f0d936"
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
