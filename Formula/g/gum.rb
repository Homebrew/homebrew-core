class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "8a5baa1e1647cdc3f7fdf91939de5372791ab133117416c8e3d944afbf0b3c9c"
  license "MIT"
  compatibility_version 1
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "62f953e983eeeaa57e1b7cc564064a77e1db2daa592312e953b35910c1c2086b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62f953e983eeeaa57e1b7cc564064a77e1db2daa592312e953b35910c1c2086b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62f953e983eeeaa57e1b7cc564064a77e1db2daa592312e953b35910c1c2086b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e4fba4ac72c88f97e16ea1791edfdd75edf7fc71128df6d1ce12c3c052e56705"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3516c6d5516bc7107b1c1c758ac0a63181362a3cda31f07f4b5dc4707e42405a"
    sha256 cellar: :any,                 x86_64_linux:  "ef27dde74918165706959ed46799fb50fa3a03c88e02582ba584835b8a8c007a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}")

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
