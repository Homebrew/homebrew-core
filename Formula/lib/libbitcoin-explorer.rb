class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.8.0.tar.gz"
  sha256 "c10993ab4846e98ec4618ca2d2aab31669dc091fa2feb17d421eb96b9c35c340"
  license "AGPL-3.0"

  bottle do
    sha256 arm64_ventura:  "8f6b2f1752e487ac635b6f807c88051d1458792b28b00f99c8f4128c031d5dea"
    sha256 arm64_monterey: "8905b2ce3cc9a3b8cbdfeb7bc06b2d894ab99cd0992b4f457bffc03278541524"
    sha256 arm64_big_sur:  "de0fc3d7f4f40eddec6523b5e8f3e6ad42883d2111316ffeed218c15d15d8456"
    sha256 ventura:        "e9ded55241e482320b8e9b3c2a68711b309a7b27442d64cb71b27a28c82aceed"
    sha256 monterey:       "c8bc9fdcbc6be70ff5a9d01d4d59878cb4c681f6d60143157a68dee3275835df"
    sha256 big_sur:        "bac7f9ba8045541c6d9ec1793233852d8ee6b0b4ecda84e38ade70b80e3a9aae"
    sha256 x86_64_linux:   "a3c4084ff4fd08b3dd0b961ab95df7510d0542891ff347d1986409bc7dd38871"
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
