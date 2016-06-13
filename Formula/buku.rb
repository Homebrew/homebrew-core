class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.2.tar.gz"
  sha256 "f3aa56404ac08f03b87a6b1d4606fab0404993677facad2beb195e6f2b251c3d"

  bottle do
    cellar :any_skip_relocation
    sha256 "be15ff762a030825bd946b2f284efe52739dd16f431af04118a412c11592ebb8" => :el_capitan
    sha256 "118f95dae5477b26d99cc84e9480c72a60a6d92f26c53368b913abad48e734a7" => :yosemite
    sha256 "ab1f5bbf4168ea6d0295decbe1b10c4a2bb3da1c85bc2251eeb3e92ff5688df9" => :mavericks
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
