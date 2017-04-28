class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.1.tar.gz"
  sha256 "4a5ab167e82552fb18fe76d80bffe4c3fbb97fea3de87200af8dc3f4662ff7dc"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90604c6e10b8f29c2c483737a9cf89cf69fc87479b9f18acc6e45c50e338bce5" => :sierra
    sha256 "90604c6e10b8f29c2c483737a9cf89cf69fc87479b9f18acc6e45c50e338bce5" => :el_capitan
    sha256 "90604c6e10b8f29c2c483737a9cf89cf69fc87479b9f18acc6e45c50e338bce5" => :yosemite
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
