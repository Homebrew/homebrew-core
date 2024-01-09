class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.2.1.tar.gz"
  sha256 "a1bd97fd1b46f9ba4ffaac0cf6cf1e920b49bf6ec753870ad0e6e07a72c2de2d"
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
