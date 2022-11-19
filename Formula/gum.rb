class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.8.0.tar.gz"
  sha256 "80d0000d8eaf1d577c76099a6747307df445ae66e368b99467d3493cce21c668"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f700f4ac78280c9f14f2ef4e2a59511701db063f26d08473a7ded1132be33b1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0e305464c1c947462693fd51d0527d9eefdccbb5d753a8341bfaea3acc438c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98e3843734800ed758608b8c9228a4e144431ab58ced3bac601b5c335fd5be1d"
    sha256 cellar: :any_skip_relocation, ventura:        "c52da43cfe5fec8ab3f655b16381db7b9c23c7e8d6dd3830abd4b0d564d339b3"
    sha256 cellar: :any_skip_relocation, monterey:       "1312e2bac2cd1f0731bc77395c83233b49459747c3f9344c905f1ffa14b21905"
    sha256 cellar: :any_skip_relocation, big_sur:        "98dbe8a090f59465b6bb1aff788bff0495af397e7c2f0b127dcb9a4cfcb11685"
    sha256 cellar: :any_skip_relocation, catalina:       "587bef4576990fba2619395b8e182029c69d2a2990e020aae2a0c1e07d404382"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446a0c2709dc87dce0772f9f94b0be704f962398b165f33ccd2d2cddbacbfbf0"
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
