class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.05.10.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.05.10.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "ea987dc7851810b924255204f6bdb9c9c73934e61b3dc800cbd2d165e6ef1856"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c51b57e3c45e430ebc91cf840cefa69893253fe3829902341154d3c9556d0af"
    sha256 cellar: :any,                 arm64_monterey: "d527a40307c155c13b003ade474e720e7cecdeb42d52b0a5c9d7773799a65bbd"
    sha256 cellar: :any,                 arm64_big_sur:  "d609fec1c8397749d8180a5e36f66f4fc5730697de61b2d1780c99308001c504"
    sha256 cellar: :any,                 ventura:        "dca5d441cfd741c72f6dd1844312cead37c7e686ae0dc978c00820d5b76966e7"
    sha256 cellar: :any,                 monterey:       "7773bc476e95ed0db91d473aa416d96ab852fd6b9735fd4274943a2564866369"
    sha256 cellar: :any,                 big_sur:        "1ceaaa9f3760925f11d73e2182fd2c9acb969bd4deddbb268b6f9b41645b9de0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "132987b7182b9a85a31e00edcb5c6776f7b837d53c71e02feefded2c3d8204b1"
  end

  depends_on "openssl@3"

  # Fix usage of IN6ADDR_ANY_INIT macro (error: expected expression). See:
  # https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/netinet_in.h.html
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/2eabc6f/openrtsp/openrtsp.2022.11.19.patch"
    sha256 "33f6b852b2673e59cce7dedb1e6d5461a23d352221236c5964de077d137120cd"
  end

  def install
    # Avoid linkage to system OpenSSL
    libs = [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
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
