class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.01.19.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.01.19.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "a7c64913f7f7007c5fdc29ea811e3ca781f262271b3e42afdd4bc1041d86fa99"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d7ccfe658e1ff2976f054ade8f16b4a5f70beaa52920469b9c3a6b249d31c0ad"
    sha256 cellar: :any,                 arm64_monterey: "e5547bd2aeadda3e29e2b0e32f36a38feb51aa9ee842f3dbc52298cb267cc6fb"
    sha256 cellar: :any,                 arm64_big_sur:  "b5fe1e2ca80a823353ade566c597b020c56150c2cce72d52d612a1aaecfd0502"
    sha256 cellar: :any,                 ventura:        "30c91e26bf1b68035ec04e776b82faf47dde9579dcd07edd2c89e5786c9985e7"
    sha256 cellar: :any,                 monterey:       "fce1ac7882dbc3865c25d0abe8a986437a759867b5738a18ac7bd524bb26bb9a"
    sha256 cellar: :any,                 big_sur:        "54a81ef8214b07a7d0c048ab3771fb7613b22f023de55af074ce4c9ca124fd24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70c3b460397c0efda7cf07de42778bdfab0696c5c06a9aa1e9d4b2080b47161e"
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
