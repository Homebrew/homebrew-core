class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "06403707671e9b2af386640d8b9f6079efc0aadf77e8f6b091bd191fe16c1264"
  license "MIT"
  compatibility_version 1
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9909c2899539ee2e31e3ba5e5b672e27613b2ed6a3728cf0a317cc8063278aef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9909c2899539ee2e31e3ba5e5b672e27613b2ed6a3728cf0a317cc8063278aef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9909c2899539ee2e31e3ba5e5b672e27613b2ed6a3728cf0a317cc8063278aef"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "014dd90a816a7ca29194e1b4287c3029c1abe04a975126dfc9f04a81de242c6f"
    sha256 cellar: :any,                 x86_64_linux:      "2470131a951e140ddc0d511171473d395f52c9057eeea6617b0ee18e346572fc"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
