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
    sha256 cellar: :any,                 arm64_monterey: "6ef35ffdaaa665650175bbd94701798e64a44ad980751a3676c1d67b8d1b1c90"
    sha256 cellar: :any,                 arm64_big_sur:  "541cb3e2fd7c1658cfa32ccbffc02fc2ce85e2d57a6d7cb76f7758a7273f8b07"
    sha256 cellar: :any,                 monterey:       "99d1f556b3572e1950d36c3cb6c400b3f5526ff0e252703aed980dfc5585519a"
    sha256 cellar: :any,                 big_sur:        "9e1fdd1d0d8141c5e6d5a0d9f6664be16b10124eedf42d8581897143135b29d2"
    sha256 cellar: :any,                 catalina:       "137cf0d981b87592002815c4672731ce4ed095d4d5677b9325e5e39cb091f7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "147692a2be33bcf6de91672ad7081dede6da08fdc63b7e9850058879fc1953c2"
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
