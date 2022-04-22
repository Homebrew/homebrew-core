class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.7",
      revision: "18c19174a2a892ff3157a4a3a8bb06ab6dcb50fe"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41edadfd889de178d318de62ee9a8020cdcb25ae9b1bb9167449da5ce7e1f366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41edadfd889de178d318de62ee9a8020cdcb25ae9b1bb9167449da5ce7e1f366"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5ebc4a0d34990f4198718eb523ef5ee73b2033803aefd1ef16e75ccb1039f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f5ebc4a0d34990f4198718eb523ef5ee73b2033803aefd1ef16e75ccb1039f7"
    sha256 cellar: :any_skip_relocation, catalina:       "5f5ebc4a0d34990f4198718eb523ef5ee73b2033803aefd1ef16e75ccb1039f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "965ca86370a6765f30ab5256d12a4a8c7e029c6b2d4f9b8a62c7f14b4e02d6c9"
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
