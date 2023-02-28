class Arttime < Formula
  desc "Clock, timer, time manager and ASCII+ text-art viewer for the terminal"
  homepage "https://github.com/poetaman/arttime"
  url "https://github.com/poetaman/arttime/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "385c8ddf39653ab52c1c1ea8edca14c19cb3eb05c8d1e6627201ccb2cc191755"
  # version "2.0.0"
  license "GPL-3.0-only"
  head "https://github.com/poetaman/arttime.git", branch: "main"

  on_linux do
    depends_on "diffutils"
    depends_on "less"
    depends_on "libnotify"
    depends_on "vorbis-tools"
    depends_on "zsh"
  end

  def install
    system "./install.sh", "--noupdaterc", "--prefix", prefix.to_s, "--zcompdir", "#{share}/zsh/functions"
  end

  test do
    system bin/"arttime", "--version"
  end
end
