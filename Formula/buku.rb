class Buku < Formula
  desc "Command-line bookmark manager"
  homepage "https://github.com/jarun/Buku"
  url "https://github.com/jarun/Buku/archive/v2.5.tar.gz"
  sha256 "27dd770837110db8348446436aca3c7ed16b2884b4064aad0deb58d4ad4a69d4"

  bottle do
    cellar :any_skip_relocation
    sha256 "7dff85c7485c4d5024f87b3886c64568b893c21e597cd493bd09b3d04bf5f8fa" => :sierra
    sha256 "7dff85c7485c4d5024f87b3886c64568b893c21e597cd493bd09b3d04bf5f8fa" => :el_capitan
    sha256 "7dff85c7485c4d5024f87b3886c64568b893c21e597cd493bd09b3d04bf5f8fa" => :yosemite
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
    assert_match "https://github.com/Homebrew/homebrew", shell_output("#{bin}/buku --noprompt -s github")
  end
end
