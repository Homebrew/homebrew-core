class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.20",
      revision: "64c6a6a23c2edba90cb2649b29ddfb16c1c21a98"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e67cfa7e60a6924294b8672c85bd3d87ca5a9e9732484538e10253f4a7545a04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e67cfa7e60a6924294b8672c85bd3d87ca5a9e9732484538e10253f4a7545a04"
    sha256 cellar: :any_skip_relocation, monterey:       "36a2b8980ce145e23cf78abeafaf3f8282740cf1d9c80f5d47800bd039404b01"
    sha256 cellar: :any_skip_relocation, big_sur:        "36a2b8980ce145e23cf78abeafaf3f8282740cf1d9c80f5d47800bd039404b01"
    sha256 cellar: :any_skip_relocation, catalina:       "36a2b8980ce145e23cf78abeafaf3f8282740cf1d9c80f5d47800bd039404b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f70075ccb617e4c1ee0a27eb740cc28d9345c2af2740e37592474296ec145823"
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
