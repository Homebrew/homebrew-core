class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.1.tar.gz"
  sha256 "d70c21b4afa30fa733ab17bb8b45291e8651f2b823fad748ffbdb3b5c3fb0489"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "8b409f0677ba59902d219d4b174b3e7ec7e273befb6dd63c69b3477151264122" => :catalina
    sha256 "b48dbfde5162c222a98fe4077b3d906e60c794dcb8db240f00d5acaa801b065e" => :mojave
    sha256 "2ba56614606510098df1b196e7191264f08f555dca1d7beaa6556718e08cb8d1" => :high_sierra
  end

  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "misc/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "misc/auto-completion/zsh/_nnn"
    fish_completion.install "misc/auto-completion/fish/nnn.fish"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"

    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
