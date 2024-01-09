class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.2.1.tar.gz"
  sha256 "dfb2427acad26f789ed576c19e892fc1b0332e26b55f956a1928dfe42c110b6f"
  license "MIT"

  depends_on "taglib"

  def install
    if OS.mac?
      if Hardware::CPU.arm?
        system "make", "macos-arm64"
      elsif Hardware::CPU.intel?
        system "make", "macos-intel"
      end
    elsif OS.linux?
      system "make", "linux"
    end
    bin.install "ncmdump"
  end

  test do
    system "#{bin}/ncmdump", "-h"
  end
end
