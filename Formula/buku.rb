class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.1.tar.gz"
  sha256 "2b80de34a8fb47d430421a2a27f80bea5195dd89d979f5911c035281998a07d5"

  bottle do
    cellar :any_skip_relocation
    sha256 "dbd8fa932bfa207a4a30c4b3541ab850aa0b003e634651737458f0444cd45775" => :el_capitan
    sha256 "c463659c95a3fa76ccdfc345cdc105e814bb00a2ad2b104d5a5ed683a72f0a6d" => :yosemite
    sha256 "24eff66c1db880ec5ce58329d4b7c0b8d2a3c000bbe74cce75209cea2a4f008a" => :mavericks
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
