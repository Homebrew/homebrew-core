class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2021.01.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2021.01.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a26a2fb43c56719e5e94bbde7d2c492eb8306aa457a5a08034c6b942c4a3b0d4"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "fce2e67f55b717cd6889b5f2bc4e21bcde69acc87ed561f5a5bab17dc1aafe8a" => :big_sur
    sha256 "4dfd0982dd0e9480a654f8b3d85ac4e66b60ab582306a8aafa9ad060eb86051d" => :catalina
    sha256 "c7bc407cea25d6f3a7e89237f8241067622a630903c4649091fcf3843c9820c3" => :mojave
    sha256 "c99d793ff2f28434edbadc70d466a7316ef7d7b8095002d78090218a9b4abe76" => :high_sierra
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
