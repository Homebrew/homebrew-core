class Nanorc < Formula
  desc "Improved Nano Syntax Highlighting Files"
  homepage "https://github.com/scopatz/nanorc"
  url "https://github.com/scopatz/nanorc/releases/download/2020.1.25/nanorc-2020.1.25.tar.gz"
  sha256 "a7466a712315391559b010c224de0dc814e7fb4227853f66692ce9c4347ece7e"
  license "GPL-3.0"
  head "https://github.com/scopatz/nanorc.git"

  bottle :unneeded

  def install
    pkgshare.install Dir["*.nanorc"]
    doc.install %w[readme.md license]
  end

  test do
    require "pty"
    PTY.spawn("nano", "--rcfile=#{pkgshare}/c.nanorc") do |_stdout, _stdin, pid|
      sleep 3
      Process.kill "TERM", pid
    end
  end
end
