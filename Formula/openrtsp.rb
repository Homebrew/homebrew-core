class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2018.10.17.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2018.10.17.tar.gz"
  sha256 "7c68d9c95b39acd309a2b6a4fc14c3837544a9be3f64062ed38d1ad6f68dc9e8"

  bottle do
    cellar :any_skip_relocation
    sha256 "409bfd3370d03a822f2e78fc660bf814acfed94f70c248c111c316e656e22921" => :catalina
    sha256 "fbf8533b65181a93a166ba5415327a4a294576c55effe2c881fbe20956772853" => :mojave
    sha256 "fbff910d3f518c592e2f64afa540a17d59db664f06ce5077e1ef7959ee1ce481" => :high_sierra
    sha256 "293bd6edd7d7de1ea39517b1809865f120570e3645acbd777b704c5ebed16189" => :sierra
  end

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats
    <<~EOS
      Testing executables have been placed in:
        #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
