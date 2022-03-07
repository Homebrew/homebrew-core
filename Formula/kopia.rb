class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.10.6",
      revision: "766cb57160477fba0935634e98c2bdfd440557f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79b623ed9bf1c0c531929173cc6afd3960e4de7ed86d7dda28684c602f501c6d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aabdf3fb00ed7ab1b6efa2d8f4494b2ca386bf0aaf1e4ca2e0d1d4f69201e791"
    sha256 cellar: :any_skip_relocation, monterey:       "4cb377e9e1aaf8ce0f77f79b7c0ef139bd16c661b799300720a8f50c8b679915"
    sha256 cellar: :any_skip_relocation, big_sur:        "b24e2722cb98b2ed5ab9117b87b2f522a1e85e5bc7303943e9e7221d74075013"
    sha256 cellar: :any_skip_relocation, catalina:       "56d4ecf2534907c189d6165af05a98aeebe17470a20877119e5feb7d11d3b310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "642473d57c7e0dcf747f122190e7a65a7cb5ec7fd92d1df47096adf47a4e1055"
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
