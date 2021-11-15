class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2021.11.01.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2021.11.01.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "abb649a344a1e84538d44ecaf4bc8c65b01b3c698480bac4706fc3043f60eda5"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "eb8e6f17f603992db2cefdefd3f453c8fd98aa12c675ff23de34133fba2af3bc"
    sha256 cellar: :any, arm64_big_sur:  "b2efe494ce7ea9a932a1988eee80eda484dadf7efe57229daef2a43c78add6df"
    sha256 cellar: :any, monterey:       "73b085518868f56bcfa4810d8b8f5ae1980060ca924c69af78e095dc0e85e12d"
    sha256 cellar: :any, big_sur:        "56f1ebaad15212a06af9a97fad53e8e7a10f2bc5e0bc00ce1688ca3d1be1ae2b"
    sha256 cellar: :any, catalina:       "1155cae9d2720ff34fc809b59cd2128a9f2a2acd808e675718a49b184a6391a0"
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
