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
    sha256 "4997a49bccb0161fbf338ada1c0a32e15d7bfa3aab05b1574b58288dd3c1afd6" => :catalina
    sha256 "4d7ec22670e90c24ecee2379942d19fa89ba0f9161f5550d3e2aa99397f7d0c4" => :mojave
    sha256 "ac28871c5453bd80e40bb6cec4d61c4d38063c696b979819afaa3c302eebf1a6" => :high_sierra
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
