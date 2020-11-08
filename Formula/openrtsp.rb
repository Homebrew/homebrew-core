class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.11.05.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.11.05.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "89bdfba7fd215e16be2c9d46a797bf85c5f7f7c46b53dc8af2d1171a658da5b7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "f309dea1f86da483c6371046ee176c5720939fc8331df3a31e58c19cb98731c5" => :catalina
    sha256 "65dbf2cfe7333a73482bc84161399781ad54f96fec6889592fd491bd37fd5575" => :mojave
    sha256 "f88ffd15dbff7bacfbc910c4d8c49d88472cb701d2cb0bba4dde0b2118a823e0" => :high_sierra
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    system "./genMakefiles", "macosx"
    system "make", "PREFIX=#{prefix}",
           "LIBS_FOR_CONSOLE_APPLICATION=#{libs.join(" ")}", "install"

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
