class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.08.10.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.08.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6ea4084337bee7ea3647af8f0faa05dfc1e19a5bf68b5a83ad914edcb1772463"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "ecc3e45e230ef4b5c782d8c0ea093b635b2ecfe5d2f0b8737204d0a480eb8a08" => :catalina
    sha256 "11ab4d6d0308760f3ede55a6cb2cc66abb2c84d0c9e3364fee06c16cebdcee02" => :mojave
    sha256 "aab797c3cbb781e563fb2eabdb9c5672b19e234fc8753d52a61774724381a05a" => :high_sierra
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
