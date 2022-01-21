class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.01.21.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.01.21.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "762579c142db3aba8c4430b223d36355a47a2546d897d2961d496f03f8e3a90e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "352e4842b8692f182488dff823ff611d481ceba25941b0e4af6dacd913e149a2"
    sha256 cellar: :any, arm64_big_sur:  "d609c87b7b7c05a167282604702698e6df60b87b9545eecdb1d1e252bbaeb5e7"
    sha256 cellar: :any, monterey:       "cfdbfcad9c88a43ef6c31367d1a6b70b5a5b77e94f6cd063f9791ba51ecf6eb7"
    sha256 cellar: :any, big_sur:        "46fb4c525109a675409dde205bbc55400966a2b82d6cf13182ed9ed8614f10cb"
    sha256 cellar: :any, catalina:       "ef870488ee01aa32a61779d6dbd88487291a709c8b8fac26f8fe5e606bc3ace9"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    os_flag = OS.mac? ? "macosx-no-openssl" : "linux-no-openssl"
    system "./genMakefiles", os_flag
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
