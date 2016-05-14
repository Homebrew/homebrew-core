class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.3.tar.gz"
  sha256 "b29fa0ea211998453ed1d918c59530dffda386f8904892442a21bcd6e81c0c48"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7d82888f19cfe670dae4b6a4cafa1f7da41e97f648f4905eaa4e34d81a2b92" => :el_capitan
    sha256 "d4c1b022a56463e3516d24c8445a1c765743ce97c27f5bea635a7c65e00b2014" => :yosemite
    sha256 "6692cfd6a59508167364c3650d16209a093a47939ba60632a2d264ed10a8079f" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    assert_match /Homebrew/, shell_output("PYTHONIOENCODING=utf-8 #{bin}/googler Homebrew </dev/null")
  end
end
