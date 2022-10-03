class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.7.0.tar.gz"
  sha256 "46e57897c43878a483914f08ecd4036208e5c28c2326311838696bc33b6c9c10"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4eda2fb0d97ea65e379c57b07883aa2bf92eb1d65015c358b0ee3ddda9fab3f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76b21e0177cf615d007f4da4c9a26b0e5201aaf0fcd6b148b7accc9630e6882a"
    sha256 cellar: :any_skip_relocation, monterey:       "471654df2292c3e2212c5342c790df6686cc45a9691cc54bfd6dcc1495e14411"
    sha256 cellar: :any_skip_relocation, big_sur:        "2842da41b1e91947b2cacd9a459c368fe340100824351d754c08716707575577"
    sha256 cellar: :any_skip_relocation, catalina:       "2165dde2605eeb88230a26bc04bcdf3fa822dcb86670400419037a8f8768b178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28736b820e8bc27ee9babf56841fe211387223a30db2dd4a7bc19b9627192b64"
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
