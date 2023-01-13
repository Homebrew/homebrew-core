class Openrtsp < Formula
  desc "Command-line RTSP client"
  homepage "http://www.live555.com/openRTSP"
  url "http://www.live555.com/liveMedia/public/live.2023.01.11.tar.gz"
  mirror "https://download.videolan.org/pub/videolan/testing/contrib/live555/live.2023.01.11.tar.gz"
  # Keep a mirror as upstream tarballs are removed after each version
  sha256 "4d6efdb693a6cb337c28a9ac042256b9c4f355fcffe8d676e63ec05d885d821e"
  license "LGPL-3.0-or-later"

  livecheck do
    url "http://www.live555.com/liveMedia/public/"
    regex(/href=.*?live[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "61e8183b5f42278d4e396de972e81ae60eb3e579bb95d8d63306ecc0d10d166f"
    sha256 cellar: :any,                 arm64_monterey: "d40fe488bfccdac97bdda54e9891a578d98aad7a5211983c7df2514a44253462"
    sha256 cellar: :any,                 arm64_big_sur:  "ce84c21f4790fb4e3e6e7987ac0a80482b5956c1949b7d64831e14d138fca27c"
    sha256 cellar: :any,                 ventura:        "3edbaf348c60114f9959c98b48269470f94f44b3b9e65e193d3ac24ac927a78f"
    sha256 cellar: :any,                 monterey:       "5ece73e3f28ac8be118565c9460cb4f5832365f358f4f8379bb1077e58b54f14"
    sha256 cellar: :any,                 big_sur:        "41082e2cc15a6aaa73f14b7e63cb7bd2414148d1fb3aa55ca5c7ba9321262841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d7a4a531d282a2c4cb0d1e1cc186fd0618d0ffa026b6a8b75a3700904fb2a0"
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
