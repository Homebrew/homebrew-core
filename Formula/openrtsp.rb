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
    sha256 cellar: :any, arm64_monterey: "a2b01c7ff258222875b3797229813eb9eed7deb05ed5e5928e0bf40f378e936f"
    sha256 cellar: :any, arm64_big_sur:  "abea9373a3aa180755d255f8d237631dda110452e11504a2368413a6fb93984b"
    sha256 cellar: :any, monterey:       "5b97cae5860fdb01b629c18514101a0bd5fc7005a0ec4c160109218c1f0f9d67"
    sha256 cellar: :any, big_sur:        "3ccd594a6c25f432b9380c095142e6bcc8ef16822e2065e62f75c951f54e7f8b"
    sha256 cellar: :any, catalina:       "63230765f8467ec1df9d439a6eaf84795f0461524571a1399a3a5a0102f0b371"
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
