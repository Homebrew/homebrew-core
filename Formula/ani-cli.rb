class AniCli < Formula
  desc "A cli tool to browse and play anime"
  homepage "https://github.com/pystardust/ani-cli/"
  url "https://github.com/pystardust/ani-cli/archive/refs/tags/v1.5.tar.gz"
  license "GPL-3.0"

  depends_on "grep"
  depends_on "curl"
  depends_on "openssl"
  depends_on "cask"
  depends_on "aria2"
  depends_on "cask"
  
  def install
    # Resolve cask dependencies
    system "/usr/local/bin/brew", "install", "--cask", "iina"
    bin.install 'ani-cli'
  end
  def caveats
    <<~EOS
    Add the following in your ~/.zshrc or ~/.profile:
      alias ani-cli='ani-cli -i'
    EOS
  end
end
