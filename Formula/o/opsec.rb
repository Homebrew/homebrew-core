class Opsec < Formula
  desc "Animated OPSEC meme for when you meant to type ls"
  homepage "https://github.com/yazidears/opsec"
  url "https://github.com/yazidears/opsec/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "d49548d8f1e3f032a9da0efd4ed6a94e33987461e8b95d641fa2c0ec4fffe607"
  license "MIT"

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "opsec"
  end

  test do
    assert_match "opsec 0.1.0", shell_output("#{bin}/opsec --version")
    assert_match "OPSEC EXPRESS", shell_output("#{bin}/opsec --once")
  end
end
