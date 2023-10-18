class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.8.0.tar.gz"
  sha256 "c10993ab4846e98ec4618ca2d2aab31669dc091fa2feb17d421eb96b9c35c340"
  license "AGPL-3.0"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "a77f5daa4276b5b3de16eda7f1a7cdb493c41b3ee3b41d98465879f89fc0656f"
    sha256 arm64_ventura:  "d5fc065a4adae41bad1efcbafa5d52f0711af9c796dedbf10d4bd1d1146e474f"
    sha256 arm64_monterey: "a4d4bcb767aece7188b6c8243981dc73bb94ae38e76723c99673360e05fd231e"
    sha256 arm64_big_sur:  "054bb3bee90b894445e989211340eb082b5f271ab1d30916a09f7ca909fa4462"
    sha256 sonoma:         "3c85de2b08a5f8eaf28734763f9b931fa92d8e2c34ce91bdaf0db3e217797328"
    sha256 ventura:        "3f5070a099083f4777bec5f31c73f9440f1dcdceca65b4e38f830c38aaddb008"
    sha256 monterey:       "480e13a7e581d74e31cfa6be2902765ec7b6bc9fda794c20125fc1652274addd"
    sha256 big_sur:        "50676d0d3790be0a842e3bb07545dd6bad666c5b8bb3f8acbe8ea5e685d21ab4"
    sha256 x86_64_linux:   "4f51230a63c0edc7078d666f53dcaee6e8e4b97a4475cded4f4e1705869f3cc6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin-client"
  depends_on "libbitcoin-network"

  def install
    ENV.cxx11
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"

    bash_completion.install "data/bx"
  end

  test do
    seed = "7aaa07602b34e49dd9fd13267dcc0f368effe0b4ce15d107"
    expected_private_key = "5b4e3cba38709f0d80aff509c1cc87eea9dad95bb34b09eb0ce3e8dbc083f962"
    expected_public_key = "023b899a380c81b35647fff5f7e1988c617fe8417a5485217e653cda80bc4670ef"
    expected_address = "1AxX5HyQi7diPVXUH2ji7x5k6jZTxbkxfW"

    private_key = shell_output("#{bin}/bx ec-new #{seed}").chomp
    assert_equal expected_private_key, private_key

    public_key = shell_output("#{bin}/bx ec-to-public #{private_key}").chomp
    assert_equal expected_public_key, public_key

    address = shell_output("#{bin}/bx ec-to-address #{public_key}").chomp
    assert_equal expected_address, address
  end
end
