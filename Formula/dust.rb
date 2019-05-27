class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.3.1.tar.gz"
  sha256 "a10e0b2bc5862928a257e05866e077866193cc673d97a711ddd63eeecd075867"
  head "https://github.com/bootandy/dust.git"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix,
                               "--path", "."
  end

  test do
    assert_match /\d+.+?\./, shell_output("#{bin}/dust -n 1")
  end
end
