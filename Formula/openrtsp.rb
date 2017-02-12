class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2016.11.28.tar.gz"
  sha256 "08b93a20bc302bed1da2f05621f37fda962dbfc272132afa6fa1058d222c238a"

  bottle do
    cellar :any_skip_relocation
    sha256 "83cc3ca4ff638b7075176fa30cbe3229ba3de5df630406740f50d26408bc5efb" => :sierra
    sha256 "703a82fa29ae783f253c464defacd0bbea6bb15743d444144021dc69a7a7f0c4" => :el_capitan
    sha256 "a74de2f856a6ece4d9d59f11bd4f7caf9694a350548a74b254ff16c58d1433e7" => :yosemite
  end

  def install
    if MacOS.prefer_64_bit?
      system "./genMakefiles", "macosx"
    else
      system "./genMakefiles", "macosx-32bit"
    end

    system "make", "PREFIX=#{prefix}", "install"

    # Move the testing executables out of the main PATH
    libexec.install Dir.glob(bin/"test*")
  end

  def caveats; <<-EOS.undent
    Testing executables have been placed in:
      #{libexec}
    EOS
  end

  test do
    assert_match "GNU", shell_output("#{bin}/live555ProxyServer 2>&1", 1)
  end
end
