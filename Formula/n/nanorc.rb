class Nanorc < Formula
  desc "Improved Nano Syntax Highlighting Files"
  homepage "https://github.com/scopatz/nanorc"
  url "https://github.com/scopatz/nanorc/releases/download/2020.10.10/nanorc-2020.10.10.tar.gz"
  sha256 "cd674e9eb230e4ba306b418c22d1891d93a3d2ffdf22234748d3398da50dfe64"
  license "GPL-3.0"
  head "https://github.com/scopatz/nanorc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf71c9da19d2ac1b05163bd9f92ea86adc475ca15d3e95101c91d788ff781625"
  end

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
