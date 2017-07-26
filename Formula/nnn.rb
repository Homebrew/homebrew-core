class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.3.tar.gz"
  sha256 "eb3a3248dd70f20a3a82b8e1bdfd35c0b2089aedeb71b14bf830c2f12a7b3b6a"

  bottle do
    cellar :any_skip_relocation
    sha256 "027311a7f496c9415dcd5c2eee2413eaf638dd3203275117e0be850833bb41b0" => :sierra
    sha256 "8a0ff9a193849895fac3583e75be1047de5fc70a75504028643128e61a20d0af" => :el_capitan
    sha256 "2c9245d1c6ee16363e3d200d140064a1955a5300cf1af7c3cb0df143082c0e58" => :yosemite
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
