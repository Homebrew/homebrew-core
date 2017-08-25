class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.3.0.tar.gz"
  sha256 "029dc350497bdaad4d8559f7954405011b9e1b996aa4d4cc124f650e2eca00a6"

  bottle do
    sha256 "b58d626cf27717e029ed02048156faccc1a326c2da9908e9ab131e3927e7b900" => :sierra
    sha256 "4f2ffa8d3b0b443e338e57a629ebd2e2e4188bb89d852e9c6ad8541baa47adea" => :el_capitan
    sha256 "e60dd458a7ec131ce8b3e86a5c871d03c8f90fac245c68958c79c10f913f8856" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

  resource "secp256k1" do
    url "https://github.com/libbitcoin/secp256k1/archive/v0.1.0.13.tar.gz"
    sha256 "9e48dbc88d0fb5646d40ea12df9375c577f0e77525e49833fb744d3c2a69e727"
  end

  resource "libbitcoin-network" do
    url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.3.0.tar.gz"
    sha256 "cab9142d2b94019c824365c0b39d7e31dbc9aaeb98c6b4bf22ce32b829395c19"
  end

  resource "libbitcoin-protocol" do
    url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.3.0.tar.gz"
    sha256 "7902de78b4c646daf2012e04bb7967784f67a6372a8a8d3c77417dabcc4b617d"
  end

  resource "libbitcoin-client" do
    url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.3.0.tar.gz"
    sha256 "ac22793201a269789a5d10e92333a2f59e887256c87c2e72b20ccd023d618757"
  end

  def install
    ENV.prepend_create_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    resource("secp256k1").stage do
      system "./autogen.sh"
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--enable-module-recovery",
                            "--with-bignum=no"
      system "make", "install"
    end

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
