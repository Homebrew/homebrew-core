class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.20",
      revision: "64c6a6a23c2edba90cb2649b29ddfb16c1c21a98"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdf85b33a7f4a8970e893666e44b3050a18edbc1b91c2fc6f09c2ba10e557f13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdf85b33a7f4a8970e893666e44b3050a18edbc1b91c2fc6f09c2ba10e557f13"
    sha256 cellar: :any_skip_relocation, monterey:       "1ddb326dfca7b8ceb20db5f9369cc2c7f25c1dfedc965342a04571f9deefe276"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ddb326dfca7b8ceb20db5f9369cc2c7f25c1dfedc965342a04571f9deefe276"
    sha256 cellar: :any_skip_relocation, catalina:       "1ddb326dfca7b8ceb20db5f9369cc2c7f25c1dfedc965342a04571f9deefe276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8750ad15f21e19835f834487bd66d8dd1195ef60f8f31f5a58623bb19d39f4b"
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
