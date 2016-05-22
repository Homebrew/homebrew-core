class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v2.4.1.tar.gz"
  sha256 "0346a0e0df1091e16e6504154e7da15a98fa3fb9e76df6497c37ac76acf19924"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7d82888f19cfe670dae4b6a4cafa1f7da41e97f648f4905eaa4e34d81a2b92" => :el_capitan
    sha256 "d4c1b022a56463e3516d24c8445a1c765743ce97c27f5bea635a7c65e00b2014" => :yosemite
    sha256 "6692cfd6a59508167364c3650d16209a093a47939ba60632a2d264ed10a8079f" => :mavericks
  end

  depends_on :python3

  def install
    system "make", "install", "PREFIX=#{prefix}"
    bash_completion.install "auto-completion/bash/googler-completion.bash"
    fish_completion.install "auto-completion/fish/googler.fish"
    zsh_completion.install "auto-completion/zsh/_googler"
  end

  test do
    ENV["PYTHONIOENCODING"] = "utf-8"
    assert_match /Homebrew/, shell_output("#{bin}/googler --noprompt Homebrew")
  end
end
