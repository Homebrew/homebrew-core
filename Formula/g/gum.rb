class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "5e2bfe822c0c4c75379e462340d78d26065481263f215db5511ed2e3bb40ade5"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aacadbda3e61aabf31430021f7865c9dd93899c8e22b1e97edc10a2d043fde9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8aacadbda3e61aabf31430021f7865c9dd93899c8e22b1e97edc10a2d043fde9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8aacadbda3e61aabf31430021f7865c9dd93899c8e22b1e97edc10a2d043fde9"
    sha256 cellar: :any_skip_relocation, sonoma:        "afdf239dce1114adce1aa5deaabb7b5bf173af3db113fa2f0a12348dda34fa7d"
    sha256 cellar: :any_skip_relocation, ventura:       "afdf239dce1114adce1aa5deaabb7b5bf173af3db113fa2f0a12348dda34fa7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "254057325872566c8bf30413e604e645760f63d53fa045d4dc8e2a4953da5f8e"
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
