class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.0.tar.gz"
  sha256 "04db6d6710ce1232c779bf70137a86557e486614e20327717122bb63f36348f7"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "8632b7b8dcee68fd57c7854bcfec806397a786132aee620d97d1759cd843b687" => :catalina
    sha256 "d15803038add303de62900f66ded75964212612582f005bed080d31687d49b71" => :mojave
    sha256 "2ef65ba6e5f79506b72c79194d5aa176eae2c77a9c11ce5d7dd991a7bed8d04a" => :high_sierra
  end

  depends_on "readline"

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
