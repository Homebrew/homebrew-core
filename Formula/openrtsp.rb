class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.06.25.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.06.25.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f206309f10d281990889b7a0c92c26a7fa55ac0e8568bf594b9b27433b4db585"

  bottle do
    cellar :any
    sha256 "b0ad030b1976244e06cd87b206eb090f8110583480c0fc574dd0a3896fc107f9" => :catalina
    sha256 "ba59938a250409e9a2e7a46439312629789527c2cdffd90912cf60c3963ce954" => :mojave
    sha256 "3b8b67993c7065d47c69df729f182460a0484f8c027953c582aa489b9b509824" => :high_sierra
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
