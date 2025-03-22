class Lavat < Formula
  desc "Lava lamp simulation using metaballs in the terminal"
  homepage "https://github.com/AngelJumbo/lavat"
  url "https://github.com/AngelJumbo/lavat/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "07b11ce4d15354d8fbb85b60955c74d52d72946d509ec7dda02498adc71e2df4"
  license "MIT"
  head "https://github.com/AngelJumbo/lavat.git", branch: "main"

  def install
    system "make" # `make install` doesn't work on macOS
    bin.install "lavat"
  end

  test do
    # GUI app
    assert_match "Usage: lavat [OPTIONS]", shell_output("#{bin}/lavat -h")

    require "pty"

    PTY.spawn(bin/"lavat") do |_r, _w, pid|
      sleep 5
    ensure
      Process.kill("TERM", pid)
    end
  end
end
