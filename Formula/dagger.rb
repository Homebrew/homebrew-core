class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.10",
      revision: "f45043af34c7bb97f12850f566f4744fc115cc6d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63e6786437f595a1057c335cafdbf101d02a54101e8f09b3cde845eba02f7830"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63e6786437f595a1057c335cafdbf101d02a54101e8f09b3cde845eba02f7830"
    sha256 cellar: :any_skip_relocation, monterey:       "cfddd1d86ed419eca5cc4101aec37d7819601e60f380d0f185f6bec288014747"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfddd1d86ed419eca5cc4101aec37d7819601e60f380d0f185f6bec288014747"
    sha256 cellar: :any_skip_relocation, catalina:       "cfddd1d86ed419eca5cc4101aec37d7819601e60f380d0f185f6bec288014747"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b30e49c86e65260e435f739f9dbf25f705ea199719aa70c8d6049f8052b1d67"
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
