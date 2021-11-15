class Nbsdgames < Formula
  desc "Text-based modern games"
  homepage "https://github.com/abakh/nbsdgames"
  url "https://github.com/abakh/nbsdgames/archive/refs/tags/v4.1.2.tar.gz"
  sha256 "b4ba777791274af7db13d2827b254cf998a757468e119c6ee106ccbeafcd04c1"
  license :public_domain
  head "https://github.com/abakh/nbsdgames.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f27112c26f752624c594d5ab67af18de7e9138b985cfc4113ce293b7e9b91c58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4281d8274d3f05106a5e34a31db7498615e2b4ac89e52528a864d8d4c2fa0999"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf1f0908c51d75fd78cbc5cd301c8f586e11d3357ff552dbfe61ab802cf8bdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30a3395191ecada03c1c7c18b0c82e6833a35fdf47f5a4c98fb708e89eede2a"
    sha256 cellar: :any_skip_relocation, catalina:       "6fc7bda5fa3519d9a4c241396a0ea512e252dc43e06289059b52e8017adef885"
    sha256 cellar: :any_skip_relocation, mojave:         "88cebe1f55579632df4606eb0f9e86f4488dee8cc2b108e97a0f3bd90a6c3f90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0323c032e3636a122be2af5faca46694b70a6072e334a42996068abccde6fb7c"
  end

  uses_from_macos "ncurses"

  def install
    mkdir bin
    system "make", "install",
           "GAMES_DIR=#{bin}",
           "SCORES_DIR=#{var}/games"

    mkdir man6
    system "make", "manpages", "MAN_DIR=#{man6}"
  end

  test do
    assert_equal "2 <= size <= 7", shell_output("#{bin}/sudoku 1", 1).chomp
  end
end
