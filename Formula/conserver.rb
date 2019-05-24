class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/conserver/conserver/releases/download/v8.2.4/conserver-8.2.4.tar.gz"
  sha256 "a591eabb4abb632322d2f3058a2f0bd6502754069a99a153efe2d6d05bd97f6f"

  bottle do
    cellar :any_skip_relocation
    sha256 "97403a07aac75ec35f200f6c804c55f6e011dd472146c87c53da209f130f74a6" => :mojave
    sha256 "1a5372d2617d47faea48393dcf6dffe38d778194a7e1e7deb32f49548884b2d4" => :high_sierra
    sha256 "b86cff5c3d9803a8840b06199065fe07b29d8361457412d7063f171a42cf6b2e" => :sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
