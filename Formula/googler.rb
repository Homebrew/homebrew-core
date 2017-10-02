class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.4.tar.gz"
  sha256 "187d9369ed0d7d2db118a0144ccbc54f18a1b8e7ef24921571b80dbaaad726aa"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a340531f0d434311f16f47f44e27e4383a7970e9f8c79606ae42c50c589a756" => :high_sierra
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
