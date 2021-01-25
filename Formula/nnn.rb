class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.5.tar.gz"
  sha256 "e636d4035499a112a0ad33f1557838132ed2e39d8857c5b219714fe9f64681f3"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "5c64cb1e6f452482a993008ab9c040a1bc5d6ce1a9420ff968e2331d3dadcdb9" => :big_sur
    sha256 "bbf45030eafc9b51f479a0c8c023e2ce99e4d9e290e5db991b95698faff4f9d8" => :arm64_big_sur
    sha256 "272c2795afd613f2d2d8ac9f9a892b1cfcdc06577edec50b15cedb43b7a9593d" => :catalina
    sha256 "5805e7ec131062a1b9444d7ec1bae509ab540a00fe333ca3fb20caa0a32ccd2e" => :mojave
  end

  depends_on "gnu-sed"
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
