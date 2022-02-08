class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.02.07.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.02.07.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "6f0c1f8a71ceb506bcbf969b02b4b0c3697b4e15daeb6dcba9872c8745ce92c6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "391d9c4024e4229b9bd1e9f1abd3e7b9bb973f91df5800a76e3cd0b4b9c31ea8"
    sha256 cellar: :any,                 arm64_big_sur:  "bff3dfca03ace204fa0f0382afa7743c0c2c63b3fb5d6d5690de26336b679db2"
    sha256 cellar: :any,                 monterey:       "e0e6f915701e4321f613ce237bb409d89dcb0daa97a5635ba89077d938ca2ad1"
    sha256 cellar: :any,                 big_sur:        "54606e26d6707b8fdb2ba9bc12922e4288df3a3f50ea2db120e17c46343ebbc5"
    sha256 cellar: :any,                 catalina:       "d8f8b92773bca81e1dfe139a9bcdbebe492842cf9304a047d2670514665c7521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d2351635eeec2622f506bb7e1c28cddbb9f8e230cce4a0af08d3aa46f2c9636"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
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
