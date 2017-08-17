class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.3.tar.gz"
  sha256 "c9e259067b49554705837258bf4856b7608eb17478e989d8d19f2d31b4b6d355"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30918bc60cceb91ab08487ad6724d6c2f6abdf958df0a1981cd7d96f831f8532" => :sierra
    sha256 "30918bc60cceb91ab08487ad6724d6c2f6abdf958df0a1981cd7d96f831f8532" => :el_capitan
    sha256 "30918bc60cceb91ab08487ad6724d6c2f6abdf958df0a1981cd7d96f831f8532" => :yosemite
  end

  depends_on :python3

  def install
    system "make", "disable-self-upgrade"
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match "Homebrew", shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
