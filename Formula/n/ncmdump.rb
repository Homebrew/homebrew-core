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

  resource("test_input") do
    url "https://github.com/taurusxin/ncmdump/raw/main/test/test.ncm"
    sha256 "a1586bbbbad95019eee566411de58a57c3a3bd7c86d97f2c3c82427efce8964b"
  end

  resource("test_expect") do
    url "https://github.com/taurusxin/ncmdump/raw/main/test/expect.bin"
    sha256 "6e0de7017c996718a8931bc3ec8061f27ed73bee10efe6b458c10191a1c2aac2"
  end
  
  test do
    resource("test_input").stage testpath
    resource("test_expect").stage testpath
    system "#{bin}/ncmdump", "#{testpath}/test.ncm"
    assert_predicate testpath/"test.flac", :exist?
    assert_equal File.read("test.flac"), File.read("expect.bin")
  end
end
