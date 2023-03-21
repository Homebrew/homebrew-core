class Hexer < Formula
  desc "Hex editor for the terminal with vi-like interface"
  homepage "https://devel.ringlet.net/editors/hexer/"
  url "https://devel.ringlet.net/files/editors/hexer/hexer-1.0.6.tar.gz"
  sha256 "fff00fbb0eb0eee959c08455861916ea672462d9bcc5580207eb41123e188129"
  license "BSD-3-Clause"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man1}"
  end

  test do
    # no other tests provided because hexer is an interactive tool
    system "#{bin}/hexer", "-V"
  end
end
