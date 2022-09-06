class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.33",
      revision: "c3d3c265fd1adb05e43d2d35adbf37d1dd0ef62a"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d15fd37fc33fb144ee11f8265d9c0dc0abca4d52112e9f961a20ac89c565dc0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d15fd37fc33fb144ee11f8265d9c0dc0abca4d52112e9f961a20ac89c565dc0"
    sha256 cellar: :any_skip_relocation, monterey:       "226519cd7b90fa4759ebc694bf0792576b486b23aa7749ae619b494a23d91698"
    sha256 cellar: :any_skip_relocation, big_sur:        "226519cd7b90fa4759ebc694bf0792576b486b23aa7749ae619b494a23d91698"
    sha256 cellar: :any_skip_relocation, catalina:       "226519cd7b90fa4759ebc694bf0792576b486b23aa7749ae619b494a23d91698"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11cf975663a7a6e68c96e965b1d5dfb8033189cc15611a3844ad850d2242f41c"
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
