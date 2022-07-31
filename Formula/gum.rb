class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.1.0.tar.gz"
  sha256 "f89228867cd61ebeae0b7bcc9e8034079da256e2c6bf696a9eceb73fc4c3f2b6"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    man_page = Utils.safe_popen_read(bin/"gum", "man")
    (man1/"gum.1").write man_page

    bash_output = Utils.safe_popen_read(bin/"gum", "completion", "bash")
    (bash_completion/"gum").write bash_output

    zsh_output = Utils.safe_popen_read(bin/"gum", "completion", "zsh")
    (zsh_completion/"_gum").write zsh_output

    fish_output = Utils.safe_popen_read(bin/"gum", "completion", "fish")
    (fish_completion/"gum.fish").write fish_output
  end

  test do
    assert_match "Gum", shell_output("#{bin}/gum format 'Gum'").chomp
    assert_equal "foo", shell_output("#{bin}/gum style foo").chomp
    assert_equal "foo\nbar", shell_output("#{bin}/gum join --vertical foo bar").chomp
    assert_equal "foobar", shell_output("#{bin}/gum join foo bar").chomp
  end
end
