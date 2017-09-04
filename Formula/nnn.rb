class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.4.tar.gz"
  sha256 "f1170864c26e55d89034d555572484950998fa6d99784237d76cd4e3bf45aed8"

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
