class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.4.0.tar.gz"
  sha256 "c0ed8ee51d780a3787699de47a5b8b5e73e539376be62f4e5cd89acfd8744ba3"
  revision 1

  bottle do
    sha256 "6dd67afd894d12a06be94f2e799f7f46b57934bad7bc36aaa818c4ee0fa2bb02" => :high_sierra
    sha256 "7ea67027d293217a1366b6abfcd713869cf13bb56915b78b48670637303c21f1" => :sierra
    sha256 "19f374e4610778d791e6b597e8c67e99c21a2d769c5afc87bf03daf89b170f20" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

  resource "libbitcoin-network" do
    url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.4.0.tar.gz"
    sha256 "3ef864289fc0085dd695f34e0a2dc8619011b3d6dbd7cffe1e19651ceff27ed9"
  end

  resource "libbitcoin-protocol" do
    url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.4.0.tar.gz"
    sha256 "71b1a5b23b4b20f4727693e1e0509af8a0db4623bb27de46e273496ada43a121"
  end

  resource "libbitcoin-client" do
    url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.4.0.tar.gz"
    sha256 "7e7641b960b930735092a225ad7180b672cff63e67bb957e0b46820a303a4e2f"
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libbitcoin"].opt_libexec/"lib/pkgconfig"
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("libbitcoin-network").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    resource("libbitcoin-protocol").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    resource("libbitcoin-client").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
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
