class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2021.12.18.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2021.12.18.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "68a809a1cf15643dddb41046b4b757c4280f8c6ea40c1eb58717494de2250e37"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "b39fb614ff4b57b5bb2bfe1b1f492b4ebe1e1007757431dc37678e4981145f0b"
    sha256 cellar: :any, arm64_big_sur:  "b239559a06feac098b3ffa256274ffe08df5244340aff076e8494d5ac9429dd1"
    sha256 cellar: :any, monterey:       "9155b4f3e38b9f213075acac9904340e84d1e61eb126608ee8ce9d01473956d1"
    sha256 cellar: :any, big_sur:        "10cca988c6b2ad82f2c407bf4031d57fdcddb2239ca465d23b9542af03e33741"
    sha256 cellar: :any, catalina:       "7c670e4e05dce6ac2f179f78293ee7fc6ed0029bfb64a6356d814aea5eb7e7cd"
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
