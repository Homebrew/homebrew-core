class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.10.6",
      revision: "766cb57160477fba0935634e98c2bdfd440557f3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9aace7affc33b85370b794d2dc595faceb2ce9658b683e3f71b90d2307b9db5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4520ba7f3577c1df2c488fda9c1fcc67c34576a72d811e78ad588321f590734a"
    sha256 cellar: :any_skip_relocation, monterey:       "79263d89764b2b139f1f1353b3315b6873e39d102b553e9ae7b59e9dc66747c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "25b0e3cc9254cf39629f86abf04a31cfbd7e246699f1ca94ccb6e91e78688c5c"
    sha256 cellar: :any_skip_relocation, catalina:       "5b9161d189b341d76bbba128919b874179894c0e6da6075bca80eb863fd72dda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "575d2c46d17999589f9efda01c41f2cd018bea6b780cf13931acccb741a7f101"
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
