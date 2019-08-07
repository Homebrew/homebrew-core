class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.9.3.tar.gz"
  sha256 "a799b0fba07593648ebef2fc4bc58d9f623d81d539686251ef842ef6ba874e2a"
  head "https://github.com/Canop/broot.git"

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
