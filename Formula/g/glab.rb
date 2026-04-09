class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.91.0",
    revision: "266e9be21808a4d52cc89b0e25e24b353ee0dc6a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4912cbd78ba470f3d706f5aabe9a7df54de6c9b27656e5cdae57f226deeb49b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4912cbd78ba470f3d706f5aabe9a7df54de6c9b27656e5cdae57f226deeb49b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4912cbd78ba470f3d706f5aabe9a7df54de6c9b27656e5cdae57f226deeb49b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "377c8bf0db9b42c640f3c405420c64e53e650dd8cb675a5a68fbd1ab3fee189c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d55146daa70b9fd173a9ecc34b1fabce287357a8c04df0cfffc5ffaeb7344be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fdcafc1c49a00c620c4d3af70828438ee6fbb305fc37e5fef1404580897f466"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
