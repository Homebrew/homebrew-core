class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.4.tar.gz"
  sha256 "859ba5bd4892016aed9a4830ee1e1b03eb74e94c4f1bd82f0288dc559f7327eb"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "ddf0361deeb681303efc74a08e5bdce4a08225bb3b9ff6cdb607d6cfb4158860" => :mojave
    sha256 "b26f8e25a48ebfa64ec49c496a625121e367075778610643181f55740edabd25" => :high_sierra
    sha256 "997ecd4a9ef2d58c17dc8a23dd83143297a434a81e9e6567097e7f5610c86a6d" => :sierra
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    bash_completion.install "scripts/auto-completion/bash/nnn-completion.bash"
    zsh_completion.install "scripts/auto-completion/zsh/_nnn"
    fish_completion.install "scripts/auto-completion/fish/nnn.fish"
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
