class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.4",
      revision: "b32c8732bc7bd932dbdb5dc42fe2434c53cfeb38"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f046a5423ab8d5b5380bab96afc08a521ef9b50da5aa047c7f6471a2e84a0c83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f046a5423ab8d5b5380bab96afc08a521ef9b50da5aa047c7f6471a2e84a0c83"
    sha256 cellar: :any_skip_relocation, monterey:       "0f39805cecfe1ebae8cac7234c5d951b547ee4c33ebdbe64b77ff3379996c774"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f39805cecfe1ebae8cac7234c5d951b547ee4c33ebdbe64b77ff3379996c774"
    sha256 cellar: :any_skip_relocation, catalina:       "0f39805cecfe1ebae8cac7234c5d951b547ee4c33ebdbe64b77ff3379996c774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f129270f2f34272065120db6e810dbf234d7d1947b95315bc4c7e10f6250143"
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
