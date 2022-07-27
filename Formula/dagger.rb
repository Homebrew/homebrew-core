class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://github.com/dagger/dagger.git",
      tag:      "v0.2.27",
      revision: "954664e6db0f548e10645848d3def287b99d53f6"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "536acdd7440242d314c679317a01410677e8d99f4012e4ae399e1f5ca5eb1038"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "536acdd7440242d314c679317a01410677e8d99f4012e4ae399e1f5ca5eb1038"
    sha256 cellar: :any_skip_relocation, monterey:       "941ce9fbae5d0a55720a2fe6bb2689f95b146ff3fc8da09ad22644551bda7216"
    sha256 cellar: :any_skip_relocation, big_sur:        "941ce9fbae5d0a55720a2fe6bb2689f95b146ff3fc8da09ad22644551bda7216"
    sha256 cellar: :any_skip_relocation, catalina:       "941ce9fbae5d0a55720a2fe6bb2689f95b146ff3fc8da09ad22644551bda7216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63bc7299c5684e15472cdb6c9ff1753703a54e2ed7329d8b6fcc407ad8e0e221"
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
