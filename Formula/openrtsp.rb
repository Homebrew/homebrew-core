class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.04.26.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.04.26.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "24fd24d53da1ac8f8282173039e99c9952186c18404b1fc3b1d4c0e9f49414e7"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "622a394f9c99ac33337c313c4230f3a181f8775556fd8599e638a3d85aceb29f"
    sha256 cellar: :any,                 arm64_big_sur:  "2f9ead171859af4e4368b8da5e7324b91c21543615b3fa2ab7db4b0d3e7a6c8b"
    sha256 cellar: :any,                 monterey:       "f375a56bcd91d78edb03fe2896bd0d73211e19219af3317e445beb1455a787ab"
    sha256 cellar: :any,                 big_sur:        "9f903163cc730e42c97132101505ad774ed1f7a1c8461d0699e8820efb34e7f6"
    sha256 cellar: :any,                 catalina:       "cc5237f1fa833ea1714fdfceb0d2ca4d8d9437bfdb7229c731eda771e70202b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c62c1e77768cbb167003e6bc8ea963ea2d4897f08a5277a4e9ed93cc643f7e07"
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
