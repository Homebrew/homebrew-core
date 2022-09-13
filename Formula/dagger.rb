class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.34",
      revision: "46adf1fbd36cd8bd1052ed4e19f10f26df39540d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe0a22ae5453f7856257d6f9dd689b53771a3446a4899eeb069a7ea1421a8f00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fe0a22ae5453f7856257d6f9dd689b53771a3446a4899eeb069a7ea1421a8f00"
    sha256 cellar: :any_skip_relocation, monterey:       "de38d7eb8c1c6634a760833975da6a36b4be4d3a6d720814e5ea15cf96922880"
    sha256 cellar: :any_skip_relocation, big_sur:        "de38d7eb8c1c6634a760833975da6a36b4be4d3a6d720814e5ea15cf96922880"
    sha256 cellar: :any_skip_relocation, catalina:       "de38d7eb8c1c6634a760833975da6a36b4be4d3a6d720814e5ea15cf96922880"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d73a8061af0e79077fb69f315bccc9f935484383dc2b198462da077eff89d0a6"
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

    generate_completions_from_executable(bin/"dagger", "completion")
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
