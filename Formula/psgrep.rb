class Psgrep < Formula
  desc "Shortcut for the 'ps aux | grep' idiom"
  homepage "https://github.com/jvz/psgrep"
  url "https://github.com/jvz/psgrep/archive/1.0.8.tar.gz"
  sha256 "76c8d716ebcf9b3a7ce3ecef2716be82477af8af7c2627f3305aca18708f1622"
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
