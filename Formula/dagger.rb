class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.17",
      revision: "0bdc0bf916e684c905252c54b7ae2cd59386e9f4"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ecb12434102a75e3b81779ef38982e67d03f61677b5214b07d9a0e380815b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0ecb12434102a75e3b81779ef38982e67d03f61677b5214b07d9a0e380815b8d"
    sha256 cellar: :any_skip_relocation, monterey:       "33afa1b863a041c96285a8a851cfdb9d927a1b5f6e35bbbd05789c9518a3ba36"
    sha256 cellar: :any_skip_relocation, big_sur:        "33afa1b863a041c96285a8a851cfdb9d927a1b5f6e35bbbd05789c9518a3ba36"
    sha256 cellar: :any_skip_relocation, catalina:       "33afa1b863a041c96285a8a851cfdb9d927a1b5f6e35bbbd05789c9518a3ba36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b620d3d8453f7eaba7703f43b044982d291f9cab7f6f853d6c98865014208c28"
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
