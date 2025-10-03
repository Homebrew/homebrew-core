class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.72.0",
    revision: "294f0726782123e38b76aa10a90f246c6a641cef"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5e51354e8b8f6741f7aadf6d4bd23e0bb10b4132a1f3b3505bbd70d6bd69b05"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5e51354e8b8f6741f7aadf6d4bd23e0bb10b4132a1f3b3505bbd70d6bd69b05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5e51354e8b8f6741f7aadf6d4bd23e0bb10b4132a1f3b3505bbd70d6bd69b05"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1c540c8169904d01396ce15359dd5c6bf0352d0e858244d058212ba1efaccb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9339140d917fb72a8a8e03c6904e078a2df4ae8c51c0dbb3f024d402411e22e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5fdbd9b59917adb24a499f744aa5bf38ead387b632f4c445dbc47e1574d3a26"
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
