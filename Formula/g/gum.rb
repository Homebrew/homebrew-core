class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a6a05f4b36ce622458091ca17345765ed1e248a6ca737bade2fa27ac2e4bdff5"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d975b143e4bcdf94529b4acedb2d9d88add075b46520d689d525285ad8cbc83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d975b143e4bcdf94529b4acedb2d9d88add075b46520d689d525285ad8cbc83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d975b143e4bcdf94529b4acedb2d9d88add075b46520d689d525285ad8cbc83"
    sha256 cellar: :any_skip_relocation, sonoma:        "db86f92a2cba55d7dc7477f39609f38a0543611f095b9a5dc9fa155817500c94"
    sha256 cellar: :any_skip_relocation, ventura:       "db86f92a2cba55d7dc7477f39609f38a0543611f095b9a5dc9fa155817500c94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "281ca3dbe15771efb7ff2fb1fec6cf6c78a61d09a8bb15e240582531edfd6225"
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
