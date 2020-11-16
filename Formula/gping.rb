class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/v0.1.6.tar.gz"
  sha256 "6d470d6dd9c4630d91feba2e76b6dddd71c240f4c62db28e7add2cc0eeb08022"
  license "MIT"
  head "https://github.com/orf/gping.git"

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
