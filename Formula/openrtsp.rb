class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.08.12.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.08.12.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6380e357076b172c757beccf7f2cc270a7ed3551748d839e2492ea0132062ff6"
  license "LGPL-3.0-or-later"

  bottle do
    cellar :any
    sha256 "0151c372ca7aeb61d849d4a0460e57b10685856f3cecef3f193964bc329bacf9" => :catalina
    sha256 "08bf0a814f8357103471ef632a3e680556d7b9d12e68ba82b0def7591c487ed1" => :mojave
    sha256 "8acc9339a9d829e9fd46bf8c707f9fefadb5dcde39ebb997b0dc7b7b2af44eca" => :high_sierra
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
