class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.31",
      revision: "8146f4d9a2c8ca715c856365dd5c8bb25203f384"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c387ded597ff08089fe4bafd22ba1f1eb6c06b415a606d86dc2cb7bf8abe92b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c387ded597ff08089fe4bafd22ba1f1eb6c06b415a606d86dc2cb7bf8abe92b"
    sha256 cellar: :any_skip_relocation, monterey:       "8924a19b9280a938b039cca411255bd8beb42243598bb716c1d9af4afbc6f3c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8924a19b9280a938b039cca411255bd8beb42243598bb716c1d9af4afbc6f3c7"
    sha256 cellar: :any_skip_relocation, catalina:       "8924a19b9280a938b039cca411255bd8beb42243598bb716c1d9af4afbc6f3c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffba47a15dad7c44f0a38d289c94cc45f3eec7fe360ebe3e76f13ff0a88a99dc"
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
