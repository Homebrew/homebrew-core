class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.114.0",
    revision: "4d7c6cda781ab2922c6f207d50cf744461c0e965"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f80174ed38e2eb5cf2dd2926dc1c8cd73b358ba5cfd65e2f765fd8321120577"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f80174ed38e2eb5cf2dd2926dc1c8cd73b358ba5cfd65e2f765fd8321120577"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f80174ed38e2eb5cf2dd2926dc1c8cd73b358ba5cfd65e2f765fd8321120577"
    sha256 cellar: :any_skip_relocation, sonoma:        "6168fa48445b2001c1c888dc5be03aacb9fe00cdcfa8cdb0a8eae7f1f430f9a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b838412a955668c93bfc845607382968a91bb618236aaf2b2817a32879f496a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b21611ac660c13a89182dfb9105ef4d38f01ac44f1cf48b91710b4ee6102b1d"
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
