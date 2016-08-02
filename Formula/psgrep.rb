class Psgrep < Formula
  desc "Shortcut for the 'ps aux | grep' idiom"
  homepage "https://github.com/jvz/psgrep"
  url "https://github.com/jvz/psgrep/archive/1.0.7.tar.gz"
  sha256 "467bc5cdd19d4fa061571d5c94094e52cfc9c32d38149750a26d16dc3b804094"
  head "https://github.com/jvz/psgrep.git"

  bottle :unneeded

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end

  test do
    assert_match $0, shell_output("#{bin}/psgrep #{Process.pid}")
  end
end
