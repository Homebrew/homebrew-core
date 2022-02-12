class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.10.5",
      revision: "512dcebaf4e4dd2b2ed04bfffb340640724f00f6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc40c8e0ed974ba5ea8a3cafa05a5dd8a5400fbc72fd8585391314fd23ea2b55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41866d63f5cc6cdb0e56bafd621b7252f784c3de160e85f0516e163a58c685d9"
    sha256 cellar: :any_skip_relocation, monterey:       "54cc61c3d4eb9a92c321bbace006b40ae3a031d6ebfb5eccf4ad35b8be5fad89"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ead702b48aac3e940399b81a6e09470ba8197c71d757d64419e7aeea0d8aef8"
    sha256 cellar: :any_skip_relocation, catalina:       "707d905cd012de78f58091fc9648f28a2355cb9058838236978ec284ca67d282"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6920ca4acad3ad3673999d8c353af39882235745e1502e01fa8e3e36b2f60d95"
  end

  depends_on "go" => :build

  def install
    # removed github.com/kopia/kopia/repo.BuildGitHubRepo to disable
    # update notifications
    ldflags = %W[
      -s -w
      -X github.com/kopia/kopia/repo.BuildInfo=#{Utils.git_head}
      -X github.com/kopia/kopia/repo.BuildVersion=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read(bin/"kopia", "--completion-script-bash")
    (bash_completion/"kopia").write output

    output = Utils.safe_popen_read(bin/"kopia", "--completion-script-zsh")
    (zsh_completion/"_kopia").write output

    output = Utils.safe_popen_read(bin/"kopia", "--help-man")
    (man1/"kopia.1").write output
  end

  test do
    mkdir testpath/"repo"
    (testpath/"testdir/testfile").write("This is a test.")

    ENV["KOPIA_PASSWORD"] = "dummy"

    output = shell_output("#{bin}/kopia --version").strip

    # verify version output, note we're unable to verify the git hash in tests
    assert_match(%r{#{version} build: .* from:}, output)

    system "#{bin}/kopia", "repository", "create", "filesystem", "--path", testpath/"repo", "--no-persist-credentials"
    assert_predicate testpath/"repo/kopia.repository.f", :exist?
    system "#{bin}/kopia", "snapshot", "create", testpath/"testdir"
    system "#{bin}/kopia", "snapshot", "list"
    system "#{bin}/kopia", "repository", "disconnect"
  end
end
