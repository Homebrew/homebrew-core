class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v24.02.2/clightning-v24.02.2.zip"
  sha256 "2904bfe15994c4990da6f3dcc4be54a7d7f6e657a23f3be2d8088abb3450983a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e3f9c9eb2534fae692ab851943190a2fe9c55a4d6f4d61026a858803e8a12dc3"
    sha256 cellar: :any,                 arm64_ventura:  "7713f1576f99bc28175a0227ae341f0e4059c9b6395cc28c1b12302aae84de25"
    sha256 cellar: :any,                 arm64_monterey: "9202d9f4bb88a3c2800d0a386227bf9300f09dc34be60d6a55027156770bcb45"
    sha256 cellar: :any,                 sonoma:         "7492e5c508a7d2ab4d804e7b46343f55fe9fd47ea2ee3b5cae86f59081bf04a0"
    sha256 cellar: :any,                 ventura:        "24f52b19c49e51404abb65cfcacb1332b69c507608f381e5efaeb7999f1b6d43"
    sha256 cellar: :any,                 monterey:       "89029cd9010a8f584b1bcf6839e83c72d4a5fe70bb53216a057d2abc7e5b7370"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8840c1fd1868c0ae1e4a1b25c3dacd8e74d5230cb873bf91508a80ea85f866a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "libtool" => :build
  depends_on "lowdown" => :build
  depends_on "pkg-config" => :build
  depends_on "poetry" => :build
  depends_on "protobuf" => :build

  depends_on "bitcoin"
  depends_on "gmp"
  depends_on "libsodium"
  uses_from_macos "python"
  uses_from_macos "sqlite"

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "install", "--only=main"
    system "./configure", "--prefix=#{prefix}"
    system "poetry", "run", "make", "install"
  end

  test do
    cmd = "#{bin}/lightningd --daemon --network regtest --log-file lightningd.log"
    if OS.mac? && Hardware::CPU.arm?
      lightningd_output = shell_output("#{cmd} 2>&1", 10)
      assert_match "lightningd: Could not run /lightning_channeld: No such file or directory", lightningd_output
    else
      lightningd_output = shell_output("#{cmd} 2>&1", 1)
      assert_match "Could not connect to bitcoind using bitcoin-cli. Is bitcoind running?", lightningd_output
    end

    lightningcli_output = shell_output("#{bin}/lightning-cli --network regtest getinfo 2>&1", 2)
    assert_match "lightning-cli: Connecting to 'lightning-rpc': No such file or directory", lightningcli_output
  end
end
