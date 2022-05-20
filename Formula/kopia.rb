class Kopia < Formula
  desc "Fast and secure open-source backup"
  homepage "https://kopia.io"
  url "https://github.com/kopia/kopia.git",
      tag:      "v0.10.7",
      revision: "5d87d817335f6d547e094ab80062113dc3a1fdf4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d9e436c0b496fb2fa9f583a85444369e5603ea3c91d93cf2f8734b7c3969141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d4f5d92550f162872645174dc5ac87dd9f15a90077954085369b238b1f12b59"
    sha256 cellar: :any_skip_relocation, monterey:       "cf3aba35c0d7f65f324b3f84509ac1aefa83d592d70357f34c9edceaf7e73595"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b859d371e9e0a698203f4bbaad8b37ed72087fb199b441336c86cdd72a1b5fb"
    sha256 cellar: :any_skip_relocation, catalina:       "3cf96ddec60ecd69e2a46fd0bfbcc72deb6696521cb2181a2168bc42c4edfb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6612289cd92f64709b727f9fd5af395635d5c5d414b8b91e30b22c386cd4b234"
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
