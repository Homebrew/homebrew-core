class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.01.11.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.01.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "3c72cf04ae80655e9d566f18114a01b9a5f12fb4123350286922e03a09af37ec"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "ecbe1315f9725f1806ff8d40eda1c9df106b9f9f55ff6f704c7df9e8eca708ba"
    sha256 cellar: :any, arm64_big_sur:  "37710d920c20df516b2ba53e24d49841307bdf70b1cdc522931b74106f5ac5e1"
    sha256 cellar: :any, monterey:       "141abc67cae1217eab51aa7122d4ee69afcb2b5bf7082cf33c150846e1425f5b"
    sha256 cellar: :any, big_sur:        "90863fd40030508077c622c174cd45340e7d9e5f62c3cbcfeb4501066b3905b6"
    sha256 cellar: :any, catalina:       "1b253b380fc6c0b874c42406d6e1cba147ce9078820f2e47dcced113c1a5848a"
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
