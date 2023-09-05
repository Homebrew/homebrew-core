class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v23.05.2/clightning-v23.05.2.zip"
  sha256 "4e3e726d56b1a64e7098ec3ce4b91e538a6033d35897a4a79831b68325eb4c7c"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "203aab4287153fd4aa021ad4366c2221c0018dd772e35eb43f7cb56fd21bfae8"
    sha256 cellar: :any,                 arm64_monterey: "906a85870a5254de4cc8a50d1bc53388b96c17725bb9556d65a3d2c2380e4d1d"
    sha256 cellar: :any,                 arm64_big_sur:  "0b0d5f5af0efb7a469d8c19c24cc47bfbb0127c3bf366b3638d01a21a9056d1d"
    sha256 cellar: :any,                 ventura:        "dff08af76e20e2d86545a2095de683551657fb1299d8bb024fa01ebacef17683"
    sha256 cellar: :any,                 monterey:       "095fc6ca690c2b308f1296d71b59fab7f12d2f950c9a22e39c794fff003e9bcb"
    sha256 cellar: :any,                 big_sur:        "48fd90e65d7cdf4cb35902d757c74461f73be54d35d79bcbdfa4497e2cda76ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eafdcf1cbe25ee45c72e373bee9d153ed5fee684d4b9437d22db239145bc4779"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libsodium" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build
  depends_on "python@3.10" => :build
  depends_on "bitcoin"
  depends_on "gmp"
  uses_from_macos "sqlite"

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "env", "use", "3.10"
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    lightningd_output = shell_output("#{bin}/lightningd --daemon --network regtest --log-file lightningd.log 2>&1", 1)
    assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
