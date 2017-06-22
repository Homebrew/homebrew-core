class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.1.tar.gz"
  sha256 "4a5ab167e82552fb18fe76d80bffe4c3fbb97fea3de87200af8dc3f4662ff7dc"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "99ddc5ef6c8d28eedec506ff5bf878a6ce5fb953a4af4a9730cc2eff7f77d532" => :sierra
    sha256 "97bb9664b8c7d9c46b9370cb85b3d917752438c91bd92c716ea59b833c6acbeb" => :el_capitan
    sha256 "97bb9664b8c7d9c46b9370cb85b3d917752438c91bd92c716ea59b833c6acbeb" => :yosemite
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
