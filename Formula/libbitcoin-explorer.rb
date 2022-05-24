class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.6.0.tar.gz"
  sha256 "e1b3fa2723465f7366a6e8c55e14df53106e90b82cc977db638c78f9bc5c47db"
  license "AGPL-3.0"
  revision 8

  bottle do
    sha256 arm64_monterey: "62e23a9ef97269830f43711bcb1353c20d3cf008ef46404427cc444fc664e433"
    sha256 arm64_big_sur:  "a0dda43b536b42b220adffe2e130153fd6dcd9e55e939944db56bbdd9f4e03f1"
    sha256 monterey:       "38d66c27871444b32587e4b79b3d858c4c1387aaf8af47340ac52fc0833bc52b"
    sha256 big_sur:        "2370fd0d2fb7f276fdea60408724b4211941a7ffce6ca8b4f49b54224d92821c"
    sha256 catalina:       "b6f18b3e70c53e1c9f22e68154ddd92936856e569f36b55bd1fd65f5b6b6f1fa"
    sha256 x86_64_linux:   "964095ad75127b2959585f9ca2ec4fc694b329c023831afb1e08d876a68bc9f4"
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
