class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.9.5.tar.gz"
  sha256 "5c75e12b94baac1dc01dd92867682df09e39a8dc6935579d0aeee004c0adc0a7"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db65c17012c29364338f863b760c6e883ccb49c9b2e323ed9d568256773b8b4d" => :mojave
    sha256 "3be541539303e45e6528f6fd766f293a06baffa4116004901b8d0b3d5dedacd5" => :high_sierra
    sha256 "a59a99308ca35e72fd682910b01c13d46834d45e0531195d58bb47aa54e35554" => :sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    require "pty"

    %w[a b c].each { |f| (testpath/"root"/f).write("") }
    PTY.spawn("#{bin}/broot", "--cmd", ":pt", "--no-style", "--out", "#{testpath}/output.txt", testpath/"root") do |r, _w, _pid|
      r.read

      assert_match <<~EOS, (testpath/"output.txt").read.gsub(/\r\n?/, "\n")
        ├──a
        ├──b
        └──c
      EOS
    end
  end
end
