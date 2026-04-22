class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.92.1",
    revision: "fcecef5594725be203a4357d6751691988f76049"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d4e957fed53a687a27584713e8b8c0a1604811f9b124be694a28905e405e1b0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4e957fed53a687a27584713e8b8c0a1604811f9b124be694a28905e405e1b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d4e957fed53a687a27584713e8b8c0a1604811f9b124be694a28905e405e1b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e1f00e3a8c2b918ae4ab210a64514da4d26c0758917b4bf2cb177a8944395f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba17671e6c696a9622e1ef6b1ff63cad22fcb650be44606f435085023ab2d4c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c076a78b941a073b8c6af651af33a59ec39963ae5a08d775e9edc00e3f6e2856"
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
