class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot"
  url "https://github.com/Canop/broot/archive/v0.9.6.tar.gz"
  sha256 "af8b36d5d4242ec1bd86925f0f664a610e7e94309686ef0874df6bc0867a0c3e"
  head "https://github.com/Canop/broot.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "03f8ef048da8c80992e8ea44b974ad3c439a4e6f16a3b0ba3685a7b37b2c1fdf" => :catalina
    sha256 "01a1070f95600dc3308ae30c88f53b2424588ccc070e20a9811c6ee8aa3b66a4" => :mojave
    sha256 "1e140bc58984129ae57938071e4dc0ab84f909857df218d8c26a7e6ffe5bb937" => :high_sierra
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
