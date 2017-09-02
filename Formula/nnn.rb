class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.3.1.tar.gz"
  sha256 "869ff4fd6441ae7c9e2d135504f1c71b5818502081de305fbd0e2dc43b414270"

  bottle do
    cellar :any_skip_relocation
    sha256 "940fa83f4e2322e226447d5481a5bf809c8d06feabdaf75ffd9f89a689279cb1" => :sierra
    sha256 "152d3ba36196ea02ab8fc7d05c4f5bcd7d44408d20069463ae664f5d33992b3b" => :el_capitan
    sha256 "44672ea1e59007ab09493f591c1da9ae3b949fbb3648738f1da4f494266402ff" => :yosemite
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match "cwd: #{testpath.realpath}", r.read
    end
  end
end
