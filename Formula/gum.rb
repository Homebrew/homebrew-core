class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/v0.8.0.tar.gz"
  sha256 "80d0000d8eaf1d577c76099a6747307df445ae66e368b99467d3493cce21c668"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d84aab2f59fd2237cf701dea29c35892b8094ede3aa84f32a8973b449f7b9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "316b2fa706ab30d2e41d6fdb98215df7e1c3793077cad12ec83e74e46929cc6f"
    sha256 cellar: :any_skip_relocation, monterey:       "c6afff9d221c54781e9bc017a17e639f95a16891e40e8c78c201e8671d0967b6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2be685a5b8705f553733c825fb68a5489e98e7efac0ec71d553cf853e7ed57c4"
    sha256 cellar: :any_skip_relocation, catalina:       "066e1750ebab205dd3eede8da0604e1023b5a38045f9558c0e119c27fae83023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cae18288950e7a2ae9eda9182acb59cfdf94eae4dd5cf7fbd50a92ec840464b"
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
