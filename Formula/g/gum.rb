class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "cedcb16ee99149236dd1b0aa786a76fa49ae37da87d0a9a065d4db16a05a5496"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0777a7b361f46a1445a66b4fef79ab48ef25b95003123f623e7101245e0c3904"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0777a7b361f46a1445a66b4fef79ab48ef25b95003123f623e7101245e0c3904"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0777a7b361f46a1445a66b4fef79ab48ef25b95003123f623e7101245e0c3904"
    sha256 cellar: :any_skip_relocation, sonoma:        "f271722cf9f927416a1d3b7eb43d84f49f0ae33c422e00f83e4b42a0c55b6d74"
    sha256 cellar: :any_skip_relocation, ventura:       "f271722cf9f927416a1d3b7eb43d84f49f0ae33c422e00f83e4b42a0c55b6d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e0808d8dffcc35da6bf9397fc67451c0cfd8ab0ec39e0118227dcb50fe19f50"
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
