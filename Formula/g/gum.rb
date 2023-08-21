class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.11.0.tar.gz"
  sha256 "51c715634c0b9c690874d1a4c42f5057797585353d8af3d9f8d86ed2d216c250"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b1db2205018f5fc41ca20af214a612dc62634c0c61e7319a3ebc3c6cb0c453a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b1db2205018f5fc41ca20af214a612dc62634c0c61e7319a3ebc3c6cb0c453a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69dcc08e6af7d63cd9fb280c102b831be2f9c31bc5b6829d965bd44a451805bb"
    sha256 cellar: :any_skip_relocation, ventura:        "6af2bf3b2d7f66e200c2b553c828bd3b913cd8b6c34036cfd126a2d3e75d41c9"
    sha256 cellar: :any_skip_relocation, monterey:       "6af2bf3b2d7f66e200c2b553c828bd3b913cd8b6c34036cfd126a2d3e75d41c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "6af2bf3b2d7f66e200c2b553c828bd3b913cd8b6c34036cfd126a2d3e75d41c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26e6aff009fad33922da529846d3c081953fe1ca216fd2acc3ee97faed64a744"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    generate_completions_from_executable(bin/"gum", "completion")
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
