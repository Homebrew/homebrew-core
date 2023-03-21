class Hexer < Formula
  desc "Hex editor for the terminal with vi-like interface"
  homepage "https://devel.ringlet.net/editors/hexer/"
  url "https://devel.ringlet.net/files/editors/hexer/hexer-1.0.6.tar.gz"
  sha256 "fff00fbb0eb0eee959c08455861916ea672462d9bcc5580207eb41123e188129"
  license "BSD-3-Clause"

  uses_from_macos "expect" => :test
  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    script = (testpath/"script.exp")
    script.write <<~EOS
      #!/usr/bin/expect -f
      set timeout 10
      spawn hexer
      send -- ":q\n"
      expect eof
    EOS
    script.chmod 0700
    system "expect", "-f", "script.exp"
  end
end
