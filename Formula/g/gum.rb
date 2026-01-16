class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "763a7f89dfebf8e77f86e680bace48a09423cfb9e4b4f4ba22d2c9836d311f95"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe88a443c148f8f6fc401cf6dfe57ad4af214feb85163c8b15c6d6423edb6c1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "901cb800319abaade91650d15c8023b6b810ef61eca36750880eb084269161eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "901cb800319abaade91650d15c8023b6b810ef61eca36750880eb084269161eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "901cb800319abaade91650d15c8023b6b810ef61eca36750880eb084269161eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "e56fe5dc19856295e738967aa43c63ee61afb66df20b51aa1076531aa849db40"
    sha256 cellar: :any_skip_relocation, ventura:       "e56fe5dc19856295e738967aa43c63ee61afb66df20b51aa1076531aa849db40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "754abdb73b22a1d828430072b07fffd9314d8db96cd3ef92dffb4c794c7c3a10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4606f16bda2cdeea33c9b4528617d4262eda00905892440d8d438f13fd27dab"
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
