class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.9.5.tar.gz"
  sha256 "5c75e12b94baac1dc01dd92867682df09e39a8dc6935579d0aeee004c0adc0a7"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5de9d31894d226465acc0a01513dc741bedf1ebb68a7ebcf24ab89a4ca450b1" => :mojave
    sha256 "d91e5ad477b328c9c0e95a909288e8067ab3ad163f46943445f0ea8330dc7f11" => :high_sierra
    sha256 "d98ddc097267497289e417ff5a7f00a9d94ae936765b2caa1c524a3458c039f2" => :sierra
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
