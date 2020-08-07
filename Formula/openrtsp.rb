class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2020.07.31.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2020.07.31.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4bba6b249b714d88a634e4e6e10982abe5e13c7a5d9a01a959d620002a5f25f9"
  license "GPL-3.0"

  bottle do
    cellar :any
    sha256 "96ed2108f05af0e69f5d8ca0dee31c20c448d1f31d483e0c8fdf104314760484" => :catalina
    sha256 "6f5d0d67092381f169ca9054a900121eee275dd69533822b0170e64f8371c3a9" => :mojave
    sha256 "b7ed3ed9d779d38de8a725503b34c392a0b1953111b764b2518a233f36cc4786" => :high_sierra
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
