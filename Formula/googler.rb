class Googler < Formula
  desc "Google Search and News from the command-line"
  homepage "https://github.com/jarun/googler"
  url "https://github.com/jarun/googler/archive/v3.5.tar.gz"
  sha256 "55ff07648257f5d2d642d1f5d6bd682e6aa32605755d4040dac4ef787257cbea"
  revision 1
  head "https://github.com/jarun/googler.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92ad1a513ea6e9d909e284f5db84a63e134416ab6a3b17726703766e275bbf65" => :high_sierra
    sha256 "92ad1a513ea6e9d909e284f5db84a63e134416ab6a3b17726703766e275bbf65" => :sierra
    sha256 "92ad1a513ea6e9d909e284f5db84a63e134416ab6a3b17726703766e275bbf65" => :el_capitan
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
