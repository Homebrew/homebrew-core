class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "c1950ef71284189436712f385adbf1a3d8df20a8735c9add5344601aedb97ac1"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cee86df817fdb16d9961c3981d4a0f6645cad0f5042e4c65abe684506cf798bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee86df817fdb16d9961c3981d4a0f6645cad0f5042e4c65abe684506cf798bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cee86df817fdb16d9961c3981d4a0f6645cad0f5042e4c65abe684506cf798bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "b57c113558bf1b0c03623d97a439fde74859c278a7af13c56a155b991b5c9e36"
    sha256 cellar: :any_skip_relocation, ventura:       "b57c113558bf1b0c03623d97a439fde74859c278a7af13c56a155b991b5c9e36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f8f02e178b2afe8397ee316823a12e8db6f9dcc40826bdda71ba0840278d7af"
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
