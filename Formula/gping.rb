class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v0.1.7.tar.gz"
  sha256 "8ea062bf704bf00a1986b2740a26d46692554a22cf49fbfb434ddf9726e3d779"
  license "MIT"
  head "https://github.com/orf/gping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23b1fc9ef364feeca2c3a9101358a2b30d19b88f75fb376ee9705e59895670df" => :big_sur
    sha256 "3620b468fb75ab8fccd2bab0bae02adedc8c240214dd7ea0989b6eb066e84ad6" => :catalina
    sha256 "c996f5ffcdc3fb78d77f3db30c789162b805b8e4d63600a99ca1bf60850d17c2" => :mojave
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub! /\e\[([;\d]+)?m/, ""

    assert_match "Pinging", screenlog
    assert_match "google.com", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
