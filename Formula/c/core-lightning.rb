class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v24.02.1/clightning-v24.02.1.zip"
  sha256 "733e2b41411a5882d93319883f8575e6959fe33a30e4f0de589ce7e4511a512b"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "514e442a18c9d7eca4ab38de6921d9fe547fc5725c175a31bad6507445f01133"
    sha256 cellar: :any,                 arm64_ventura:  "4d65c1ede86596624f645b4a227cd751825a4207629ed6bfb7acd150f8686d53"
    sha256 cellar: :any,                 arm64_monterey: "5b62e34c8ecb713a7f83579549b43f8a0142f3b815e8f8b45e8ca317383d9245"
    sha256 cellar: :any,                 sonoma:         "2e2ab20a5f069e86dd92d125f78d45af1b242ba458d83dd1da260af97ec3bbd4"
    sha256 cellar: :any,                 ventura:        "983f7bf96b03dbcabe3c4916f4fc77a0404b7b0646c05e40ba553da6b17a66a2"
    sha256 cellar: :any,                 monterey:       "934684ac91abbb88ff17a47b1fb2aa66016d57aca8d6e57769ea2c5295ebf146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9701bdf8f522fb33410e911aa4949af2f90f4b60e2215115f367f5d62db607a"
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
