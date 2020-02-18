class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.02.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "df105ad85cdcf88c56ea669733273bb1c41c5148469ee1e43b6396e24f66bfde"

  bottle do
    cellar :any_skip_relocation
    sha256 "409bfd3370d03a822f2e78fc660bf814acfed94f70c248c111c316e656e22921" => :catalina
    sha256 "fbf8533b65181a93a166ba5415327a4a294576c55effe2c881fbe20956772853" => :mojave
    sha256 "fbff910d3f518c592e2f64afa540a17d59db664f06ce5077e1ef7959ee1ce481" => :high_sierra
    sha256 "293bd6edd7d7de1ea39517b1809865f120570e3645acbd777b704c5ebed16189" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<~EOS
    Testing executables have been placed in:
      #{libexec}
  EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
