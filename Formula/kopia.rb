class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.11.3",
      revision: "317cc36892707ab9bdc5f6e4dea567d1e638a070"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "726ac3174e21db2f97a91c43c2d868b8cebd2c58d5a2d2c8035265b25ea69537"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c6b0c1288a916766ed9297de5df4b2f45f66d35fce711d965bec29795ade6259"
    sha256 cellar: :any_skip_relocation, monterey:       "ae4ec42e3f22dca08770a707d58b3b36d7e9440c4ad8fbf46418778e94895808"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa825300eea1ceb7316fd44dd5f94996991cd03e13f5c104931033ad69d9477a"
    sha256 cellar: :any_skip_relocation, catalina:       "18090791d86e85f1dcb766a1ca2117d6e74b78f2fe6c731f1a9bb715da775283"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "467460338de0026a88fb2847edb2db0d099e61c0fab88b2c945bd1aead3f9f1f"
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
