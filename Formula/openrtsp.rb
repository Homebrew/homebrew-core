class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2021.08.24.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2021.08.24.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "ce95a1c79f6d18e959f9dc129b8529b711c60e76754acc285e60946303b923ec"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "037bd7b7f6b47749662992483a26c35707c8242bddfa35f58f2c7bb8d6d0da2e"
    sha256 cellar: :any, big_sur:       "d6ae6c46e3e3917d3da47c3dfd1b9cd41830a2383ce561eea8f1270692cc1a6d"
    sha256 cellar: :any, catalina:      "afa2457a34179559b6e6a107826d22aea0e633543395a3d18a6206b0bf75c8e6"
    sha256 cellar: :any, mojave:        "3cfb1652550415fd0b7fb9e9c5ea6e1841dbc4b3b70910e0bb34866f8c8500fc"
  end

  depends_on "openssl@1.1"

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@1.1"].opt_lib/"libcrypto.dylib",
      Formula["openssl@1.1"].opt_lib/"libssl.dylib",
    ]

    system "./genMakefiles", "macosx-no-openssl"
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
