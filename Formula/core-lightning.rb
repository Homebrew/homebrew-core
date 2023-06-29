class CoreLightning < Formula
  desc "Lightning Network implementation focusing on spec compliance and performance"
  homepage "https://github.com/ElementsProject/lightning"
  url "https://github.com/ElementsProject/lightning.git",
      tag:      "v23.05.1",
      revision: "484d4476256815056e5d82991d677553c74315c1"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "502288a3ef4ea4669d2dcbe2d19b54949ade9aaaa8b8ec666b9b708031bc8bdf"
    sha256 cellar: :any,                 arm64_monterey: "642635c85400182952970544b4009bde2bd767f0196b270ce7eda2453b097dc3"
    sha256 cellar: :any,                 arm64_big_sur:  "abdf160f41f1d3f06963e9e1966a607658750ec33598a48865c71ef14afe9092"
    sha256 cellar: :any,                 ventura:        "9a5172d787b85b480f26319dd1385720090aad65286f42ccaf47341af71c8abb"
    sha256 cellar: :any,                 monterey:       "4a400e53d1a886e116d7879b87675406df10b256d931693a13ba920ad797081c"
    sha256 cellar: :any,                 big_sur:        "6b64c4ad74bb16e9f92360c786b2bbd2bb3b33ee9d646b81e04ffb2ce0f99cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "152b4bbade729494ea37a3d82e080c6521574b928ff9beb23bd06517abbed4c1"
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
  depends_on "python@3.8" => :build
  depends_on "bitcoin"
  depends_on "gmp"
  uses_from_macos "sqlite"

  def install
    remove_dir("external/lowdown")
    system "poetry", "env", "use", "3.8"
    system "poetry", "install"
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
