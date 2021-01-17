class M3u8Downloader < Formula
  desc "Download m3u8 HLS streams, written in Rust"
  homepage "https://github.com/DevNulPavel/m3u8_downloader"
  url "https://github.com/DevNulPavel/m3u8_downloader/releases/download/v1.0.0/m3u8_downloader-universal.tar.gz"
  sha256 "825ac395664ce89b48fd4d2672f551eec8eaa42e44962d979e2995a896695d4a"

  def install
    bin.install "m3u8_downloader"
  end

  test do
    assert_match "M3U8 downloader 1.0.0", shell_output("m3u8_downloader -V")
  end
end
