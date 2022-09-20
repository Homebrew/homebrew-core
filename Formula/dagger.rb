class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.35",
      revision: "46adf1fbd36cd8bd1052ed4e19f10f26df39540d"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c24e7cb1fdc19a546ef121d9c30de71c81aeda6e2f15b8859769388f59866c70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24e7cb1fdc19a546ef121d9c30de71c81aeda6e2f15b8859769388f59866c70"
    sha256 cellar: :any_skip_relocation, monterey:       "e8bf86f3fd94767eb39220ce57dcde1fb9a647e1bed47cc96a43bd704efc1a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e8bf86f3fd94767eb39220ce57dcde1fb9a647e1bed47cc96a43bd704efc1a9b"
    sha256 cellar: :any_skip_relocation, catalina:       "e8bf86f3fd94767eb39220ce57dcde1fb9a647e1bed47cc96a43bd704efc1a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "676e0ec94622e6a408f10ed1a9955ed62e3433c70c722dc7faba66a5b6be2529"
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
