class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.4.tar.gz"
  sha256 "859ba5bd4892016aed9a4830ee1e1b03eb74e94c4f1bd82f0288dc559f7327eb"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "022a321a9236783c244d432098155f4c3b70254f99e4d47da1fcfeeb28807a96" => :mojave
    sha256 "76bcd2254eb8d30931a35ce504b706c4dc13d62e5bad084953339d2558590dcb" => :high_sierra
    sha256 "e35a80a3f4aa494dcb40af44fee012e0613ef77772a6a7650e1842afff17074b" => :sierra
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
