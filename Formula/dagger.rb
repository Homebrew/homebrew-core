class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.9",
      revision: "4fc38dacb9cfc23730ad9865fcb95b7b9d9ebe69"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d83d50fe01a7bd7447157996fca8bc39468e3fae15738375a72bb421998bb93e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d83d50fe01a7bd7447157996fca8bc39468e3fae15738375a72bb421998bb93e"
    sha256 cellar: :any_skip_relocation, monterey:       "91c1df1b3a88fb67897736cdcc04df77d50ee14cf631b2142d844df824560f59"
    sha256 cellar: :any_skip_relocation, big_sur:        "91c1df1b3a88fb67897736cdcc04df77d50ee14cf631b2142d844df824560f59"
    sha256 cellar: :any_skip_relocation, catalina:       "91c1df1b3a88fb67897736cdcc04df77d50ee14cf631b2142d844df824560f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe256104774ae5752cc1180586e11abc3b701feaae85317002bb0d67a6a9ddbd"
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
