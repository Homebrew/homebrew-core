class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.0.tar.gz"
  sha256 "78b98be8f000812dcc945c0aa9ca4fa56322659c095250d4787c21bfd6383897"

  bottle do
    cellar :any_skip_relocation
    sha256 "b950c782bece56e63bac91997cc8a2a5d2a48fb5be9b272a50631dc150b896e2" => :el_capitan
    sha256 "c9f968aa2e58c58deae937b0e3054ec787461816e9d1b1fcf869cfa9a9840746" => :yosemite
    sha256 "e2ff69c1162642311edddac73ef1f6a342a2b6446689937f62b65d2784f57093" => :mavericks
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
    assert_match %r{https://github.com/Homebrew/homebrew}, shell_output("#{bin}/buku -s github </dev/null")
  end
end
