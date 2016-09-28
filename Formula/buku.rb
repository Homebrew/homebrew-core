class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.4.tar.gz"
  sha256 "55a0065389475b6993503e20271fcd1705a98c3c3aea8211971ffb055ae5d9fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "5564c75609134719ffff17e651fc26c15d6eb9fd41488409b2aff1b1f7635b88" => :sierra
    sha256 "1d3b5c36f197429e85a780c4e12144250e107949f9015dc9eab6d57673b3ea11" => :el_capitan
    sha256 "a8ce92e315c4da9bb364557b626be10ac98c6d4d8665243e891f4838eb1ab1d2" => :yosemite
    sha256 "a8ce92e315c4da9bb364557b626be10ac98c6d4d8665243e891f4838eb1ab1d2" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/buku-completion.bash"
    fish_completion.install "auto-completion/fish/buku.fish"
    zsh_completion.install "auto-completion/zsh/_buku"
  end

  test do
    ENV["XDG_DATA_HOME"] = "#{testpath}/.local/share"
    system "#{bin}/buku", "-a", "https://github.com/Homebrew/homebrew"
    assert_match "https://github.com/Homebrew/homebrew", shell_output("#{bin}/buku --noprompt -s github")
  end
end
