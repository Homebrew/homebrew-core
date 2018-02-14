class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.4.tar.gz"
  sha256 "187d9369ed0d7d2db118a0144ccbc54f18a1b8e7ef24921571b80dbaaad726aa"
  revision 1
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a89cfbe31f679fad1a15cc900718ea76246e7802718e62e6fc7b14c46ef2dc5" => :high_sierra
    sha256 "4a89cfbe31f679fad1a15cc900718ea76246e7802718e62e6fc7b14c46ef2dc5" => :sierra
    sha256 "4a89cfbe31f679fad1a15cc900718ea76246e7802718e62e6fc7b14c46ef2dc5" => :el_capitan
  end

  depends_on "python3"

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
