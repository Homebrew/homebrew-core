class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.2.tar.gz"
  sha256 "f3aa56404ac08f03b87a6b1d4606fab0404993677facad2beb195e6f2b251c3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "bdff4a2239ff386b6582ab331bad1ed1252b66a307629e030741f8a63a506268" => :el_capitan
    sha256 "422601e1eaa0b54152c89c6e97d9a01cd83020a9153725ccfd17277215b1f3cb" => :yosemite
    sha256 "928bb6c1dbb51c408ff38bc812fc8c7852c0fee4a890f4e9f6720d521ba9db3b" => :mavericks
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
