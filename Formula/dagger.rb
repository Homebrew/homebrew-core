class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.12",
      revision: "21a15a8468bd19927d6f4e9c79d1b93d76421ad6"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb055ec298719e68147c65c2bfab15a4c02175506ae110228fc362251f52bd26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb055ec298719e68147c65c2bfab15a4c02175506ae110228fc362251f52bd26"
    sha256 cellar: :any_skip_relocation, monterey:       "1e79c2dc1ec06641f8a21d0384286784e34d21412f4556f3d1d66e521d25ae74"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e79c2dc1ec06641f8a21d0384286784e34d21412f4556f3d1d66e521d25ae74"
    sha256 cellar: :any_skip_relocation, catalina:       "1e79c2dc1ec06641f8a21d0384286784e34d21412f4556f3d1d66e521d25ae74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0245df7625b2cc8f7d29cf1fc5888c505359e2871fd889087d56cd6f0b3f2e73"
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
