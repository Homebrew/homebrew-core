class Gum < Formula
  desc "Tool for glamorous shell scripts"
  homepage "https://github.com/charmbracelet/gum"
  url "https://github.com/charmbracelet/gum/archive/refs/tags/v0.14.3.tar.gz"
  sha256 "954e37c4c35e877bffd5bec7c794bee254db95f8a4e005136d94c7db456db398"
  license "MIT"
  head "https://github.com/charmbracelet/gum.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "621acf770200872c2705fa5a7a72e484e985e3632540b888f6c1cd775b3b8389"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621acf770200872c2705fa5a7a72e484e985e3632540b888f6c1cd775b3b8389"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621acf770200872c2705fa5a7a72e484e985e3632540b888f6c1cd775b3b8389"
    sha256 cellar: :any_skip_relocation, sonoma:         "80073b4db98b15962b4aad3b3280a566d17240c0c046e2c55cb42ebe14fdba4c"
    sha256 cellar: :any_skip_relocation, ventura:        "80073b4db98b15962b4aad3b3280a566d17240c0c046e2c55cb42ebe14fdba4c"
    sha256 cellar: :any_skip_relocation, monterey:       "2e79884835afbad4c372c8ca7c45f5a51559798725ae49607d9eb8b03adec858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9efabe044600a8c4501db1db79e7b42df922bc71330aff690ff52515a30d378d"
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
