class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.6.tar.gz"
  sha256 "514218f5155a2c1bd653462a503507beafca9d7ddff7203aeabb3ab4812e4b44"
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :high_sierra
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :sierra
    sha256 "543a26a00407a7677a9f568c37887acf16d2efab36f86df00f17b2c87ed0e7ea" => :el_capitan
  end

  depends_on "python"

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
