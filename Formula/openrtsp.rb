class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2022.06.16.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2022.06.16.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "f38394430fbe44da87dec018e12eb25d1257658fb94f455d4c852a10bb95755d"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "90b741d775a1ec4a555c18f58c1ca317fd822bc953c22aeb49d670e1bd3a639c"
    sha256 cellar: :any,                 arm64_big_sur:  "aac8da6bba8d62e6baff8db4a6ebc4656e6e8b20828e7b48ac12accea899d13b"
    sha256 cellar: :any,                 monterey:       "e3bf0920edda0bc718418cc9fb5c8347132a008f9e2044c04a430bec531f1af4"
    sha256 cellar: :any,                 big_sur:        "120f24e6ac1eb473c53698ae8673e15ce82445d5eebd4ae1f31ef0e1933bdae2"
    sha256 cellar: :any,                 catalina:       "ce8bb2ae79bd627a44b800c8741ed8cce78909b79c7f9b51b9a4c92f037fe6fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b399b1297f716c35bfa98f93888560387521b1b2b3bb53d5e9ebc5ecbb9c905d"
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
