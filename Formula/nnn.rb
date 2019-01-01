class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v2.2.tar.gz"
  sha256 "88dd08d624ae7a61ef749b1e258e4b29ed61ba9fcc5a18813f291ce80efc5e74"
  head "https://github.com/jarun/nnn.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "56012aba00b1e0595bb10e80b5f8726f304b5ec066b642b456e227a4ac3082a9" => :mojave
    sha256 "2da013eba898c6367c940b77e70eb8ae176788f3522d6ff292896dd0ce563329" => :high_sierra
    sha256 "1b35c3ee88b07b0ff98a38fb0aff3811212d92ccd4bee2ff68237bcc8cf52b55" => :sierra
  end

  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
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
