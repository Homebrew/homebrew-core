class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.4.tar.gz"
  sha256 "55a0065389475b6993503e20271fcd1705a98c3c3aea8211971ffb055ae5d9fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdac3a433cbdbd5bab8cd5b7525fe6cb3c93c78805c749797d1459cb351f6af9" => :el_capitan
    sha256 "168767cba9288b6908584b6bcbe061557e42aef95d65460e8f9e4e7977118501" => :yosemite
    sha256 "e7c6898a6cce5ead15a121664262dfff5e6e7b2c97817277ed110b0905e0498e" => :mavericks
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
