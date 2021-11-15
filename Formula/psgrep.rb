class Psgrep < Formula
  desc "Shortcut for the 'ps aux | grep' idiom"
  homepage "https://github.com/jvz/psgrep"
  url "https://github.com/jvz/psgrep/archive/1.0.9.tar.gz"
  sha256 "6408e4fc99414367ad08bfbeda6aa86400985efe1ccb1a1f00f294f86dd8b984"
  license "GPL-3.0"
  head "https://github.com/jvz/psgrep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ec88e4f8662da264f6312ba3d454887825f21285f39c926f9f2d80f5b035d02"
  end

  def install
    bin.install "psgrep"
    man1.install "psgrep.1"
  end

  test do
    assert_match $PROGRAM_NAME, shell_output("#{bin}/psgrep #{Process.pid}")
  end
end
