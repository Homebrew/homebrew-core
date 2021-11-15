class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.6.0.tar.gz"
  sha256 "e1b3fa2723465f7366a6e8c55e14df53106e90b82cc977db638c78f9bc5c47db"
  license "AGPL-3.0"
  revision 7

  bottle do
    sha256 arm64_monterey: "e2a189dd066f9d5fa56f5aeebf8a2346a5cf4ab17f001c836436d00a038532a7"
    sha256 arm64_big_sur:  "34d709bfefd23505e07cabcbedacf3a2869f6220e706cd96267d70e89caf5479"
    sha256 monterey:       "ecf247fbfaa8aa9ebb90f632af460826e03a479791eac9525483d5f5b9f11e24"
    sha256 big_sur:        "bb1687e4d167c4468a50df06d4bfb9cabd6ce2deab7641ff5866f0d41e686eeb"
    sha256 catalina:       "fc49fe144993aebd296479497a30ed2441da35a8c34e3e646bc07a93dbb59873"
    sha256 mojave:         "a965f788815e2e420fb46603f62c9b455e8930258e5478becbba0280f9b5950c"
    sha256 x86_64_linux:   "c96bb170eab0fe2bac4928ba3b866eeabdf69731a14f0a61e7afcd8a725ba975"
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
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}"
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
