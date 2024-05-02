class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "3174a1c8ff706d57c93da33fdf477b26620ad0f7096d97e21a005132fa74756a"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77c0736800b674fe414cceae0e9d480ea34e4475912741c6be61e206ce804154"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77c0736800b674fe414cceae0e9d480ea34e4475912741c6be61e206ce804154"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77c0736800b674fe414cceae0e9d480ea34e4475912741c6be61e206ce804154"
    sha256 cellar: :any_skip_relocation, sonoma:         "d151f3cf8adc03ed1802a2f763d5aa506d89b2459eb3dbdc9aadd4ceace6857b"
    sha256 cellar: :any_skip_relocation, ventura:        "d151f3cf8adc03ed1802a2f763d5aa506d89b2459eb3dbdc9aadd4ceace6857b"
    sha256 cellar: :any_skip_relocation, monterey:       "d151f3cf8adc03ed1802a2f763d5aa506d89b2459eb3dbdc9aadd4ceace6857b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d22432556e393051a667b2db7070abb8ef3c59890787aa4ddd6af65b74e263a0"
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
