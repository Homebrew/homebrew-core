class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.16.2.tar.gz"
  sha256 "a8f53901447b13613e3445538e2c4d42fd7afb9dad9535debff1b64656b66867"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c62d6a70c600cfe99b692f3c2d642e87b1c0cb6a5284f51e8a44ce586ecc53b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c62d6a70c600cfe99b692f3c2d642e87b1c0cb6a5284f51e8a44ce586ecc53b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c62d6a70c600cfe99b692f3c2d642e87b1c0cb6a5284f51e8a44ce586ecc53b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4bbf103641e5a4e705156fb4cac645ab02056ba1988fdfcdff56629b69e8c2b"
    sha256 cellar: :any_skip_relocation, ventura:       "d4bbf103641e5a4e705156fb4cac645ab02056ba1988fdfcdff56629b69e8c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3753b658cda311926c76e45d2c4f1677f0aa371f99b13f5f320758866be72e8e"
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
