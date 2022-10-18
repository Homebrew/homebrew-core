class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "https://www.conserver.com/"
  url "https://github.com/bstansell/conserver/releases/download/v8.2.7/conserver-8.2.7.tar.gz"
  sha256 "0607f2147a4d384f1e677fbe4e6c68b66a3f015136b21bcf83ef9575985273d8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "359c7574aa5d2a1b5615428f2f8b2cae5819088ba9e6585aaaed518681f1a1b4"
    sha256 cellar: :any,                 arm64_big_sur:  "24ef2948da4bc0c63813cf99da5f57824d0c4f05a2ebce4a78487244a57b7dbd"
    sha256 cellar: :any,                 monterey:       "5f9816db29ffc68d8bdf005b98aa9414c7712ab8a8460316f164b3df85bbdc33"
    sha256 cellar: :any,                 big_sur:        "be52d70b349a98a4e73f8ef7e81bbb735ecbc2b9371807a75d305e10efeb2cba"
    sha256 cellar: :any,                 catalina:       "faea23d0c16dc484b293ee6ad05ab28224852f81b4598f7d5a4753e9e7594392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "687930209e98a3a6fee0a1484b00aa51162b3701d26db34f9c4e353c2cb5a8d5"
  end

  depends_on "openssl@3"

  uses_from_macos "libxcrypt"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-openssl", "--with-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
