class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.17",
      revision: "0bdc0bf916e684c905252c54b7ae2cd59386e9f4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c03a18a7e906f16ebe18193c1c1202b3fba3544f08d8a7ad1f679585ea0c44"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c03a18a7e906f16ebe18193c1c1202b3fba3544f08d8a7ad1f679585ea0c44"
    sha256 cellar: :any_skip_relocation, monterey:       "e7c26c91367c75e8269929f52fb5e909457af3c2197a4b4b6b0bc52cc9002f0d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7c26c91367c75e8269929f52fb5e909457af3c2197a4b4b6b0bc52cc9002f0d"
    sha256 cellar: :any_skip_relocation, catalina:       "e7c26c91367c75e8269929f52fb5e909457af3c2197a4b4b6b0bc52cc9002f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "320dbdc772448a9d0b4103da12dec7fa308a4c41c73b08679a787675dd7c8b74"
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
