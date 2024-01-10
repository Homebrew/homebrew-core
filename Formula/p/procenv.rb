class Procenv < Formula
  desc "Show process environment variables"
  homepage "https://github.com/henrik242/procenv"
  url "https://github.com/henrik242/procenv/archive/refs/tags/1.1.tar.gz"
  sha256 "7371164f700c695fe27783b4471c2817e229fa7acc20d7a8b37a49687ef5f65d"
  license "MIT"

  def install
    system "make"
    bin.install "procenv"
  end

  test do
    system "#{bin}/procenv"
  end
end
