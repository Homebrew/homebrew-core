class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "f1418522d36528b38ce604d1a9ec14ddf6284aa6a15d28a7eb5c01a872a6d436"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "0a3e584b805c966e2dbfd88d0c14fd624d5cccc7182ada2a3abdf85ff4bd81d9"
  end

  depends_on "fzf"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    ENV["TERM"]="xterm"
    system "./install.sh", "--noupdaterc", "--prefix", prefix, "--zcompdir", zsh_completion
  end

  test do
    # arttime is a GUI application
    assert_match version.to_s, shell_output("#{bin}/arttime --version")
  end
end
