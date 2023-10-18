class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v23.08.1/clightning-v23.08.1.zip"
  sha256 "3e89e0ce0afe54cae9f27ae99d1d1009aacc59404f3e34dda1e6efa56ad2cbac"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "baab62ca3b976bfde8093407a7e47d5880c93b35c9e6a87b81ad916bb630d9c9"
    sha256 cellar: :any,                 arm64_ventura:  "6add9c773848aa7a474dd4ae47776e4bb830fc9430166b9886b3d4bb10c1f83c"
    sha256 cellar: :any,                 arm64_monterey: "f464696331e5515091210b9e860a5f9b1ea4de67d7c9d0d4892fe0895c7ce687"
    sha256 cellar: :any,                 arm64_big_sur:  "4fcf88bc7d95b0172dea7e67a017d4aa9d5e7092bf1bccd5b848b2029722288e"
    sha256 cellar: :any,                 sonoma:         "27b0f096d527b87a4fcf242e5d9d07c1a60ebe8d3181e6dc4929b753bfa7cbf5"
    sha256 cellar: :any,                 ventura:        "da47826e047c559ce53bb80d3abab89e454111e417435d1b8d2d2a07046141bb"
    sha256 cellar: :any,                 monterey:       "f374b23408ba296f9a33e1c9c9b4403143ba5b188e48695b8c7a867c029ec09d"
    sha256 cellar: :any,                 big_sur:        "5f0fbd03d05d6cd8b38803f0480f154923051c5a1053da4ddff1a5770437d796"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0950b6bee363da4f8f10095e177ba39f2014c09066918fcdc5f23554be6cc704"
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

  depends_on "bitcoin"
  depends_on "gmp"
  depends_on "python@3.11"
  uses_from_macos "sqlite"

  def install
    (buildpath/"external/lowdown").rmtree
    system "poetry", "env", "use", "3.11"
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
