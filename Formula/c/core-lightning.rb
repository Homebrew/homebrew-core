class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning/releases/download/v24.05/clightning-v24.05.zip"
  sha256 "143ec914cf34c2baeea815a3627247661d9fd86649e970d09944345deb675818"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "efdab6fb6b3802cf94db6d83dd53a53dbb8ce1cecc0dc96fbc3f16718e8f0e52"
    sha256 cellar: :any,                 arm64_ventura:  "c50c75665da2eb9f8118404e0134bf1266f0e4b28343ea73c45276a1179086b6"
    sha256 cellar: :any,                 arm64_monterey: "f33be27ba45d8b8e6eae8012771d6f8bb007d9d3b4f59753cd2477c6f266bb37"
    sha256 cellar: :any,                 sonoma:         "79e1b375686b4cacd508b77c1534ddb50f2b11e9c39243d59a6363dcb5fe3c12"
    sha256 cellar: :any,                 ventura:        "8bfcdbf40114f765d8f956bbff9b6c904e2aae3f13c53240cc5d25a16bb7ee36"
    sha256 cellar: :any,                 monterey:       "9aa7748aaf5a7ff1e3c64e48c6ebf679e1890e5ca572127bccd688c8c1744716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d9a8df043561a371db4bc4b54a398a242d4c5bbd9d808d07b549e6b3ca7d63"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "gnu-sed" => :build
  depends_on "jq" => :build
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
  uses_from_macos "zlib"

  def install
    rm_r(buildpath/"external/lowdown")
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
