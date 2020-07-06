class Nnn < Formula
  desc "Tiny, lightning fast, feature-packed file manager"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v3.2.tar.gz"
  sha256 "4ebbd024776153ecb79c75d1a58fc5cd7cd168c6e8217100b5edf322fdf9d4fd"
  license "BSD-2-Clause"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any
    sha256 "03b76b59a614592af2124a28a93002a524401fe3e59044ccaa73b0c19e4510d3" => :catalina
    sha256 "61f5a2b9a55a57121752c805f49f9978d6fccb6aae8a90d1889004b6298926a4" => :mojave
    sha256 "453a6724e2dabfe6a1b0dd059b421788f0243fc07ed3703fc822edf4584a4b6d" => :high_sierra
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
