class LibbitcoinExplorer < Formula
  desc "Bitcoin command-line tool"
  homepage "https://github.com/libbitcoin/libbitcoin-explorer"
  url "https://github.com/libbitcoin/libbitcoin-explorer/archive/v3.5.0.tar.gz"
  sha256 "630cffd577c0d10345b44ce8160f4604519b0ca69bf201f524f104c207b930aa"

  bottle do
    sha256 "95a82301e66060a2c470ec76da784150216fbdc9c3a3c038af8de29052aa527e" => :high_sierra
    sha256 "ee0600e279f96f1385410dac18f49c079c069c6b7934e00b34a3c63e5fe99481" => :sierra
    sha256 "da500353884d71273ed159380ed1b1ce788afc16bcf993ca5b6a1bbc67593c23" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libbitcoin"
  depends_on "zeromq"

  resource "libbitcoin-network" do
    url "https://github.com/libbitcoin/libbitcoin-network/archive/v3.5.0.tar.gz"
    sha256 "e065bd95f64ad5d7b0f882e8759f6b0f81a5fb08f7e971d80f3592a1b5aa8db4"
  end

  resource "libbitcoin-protocol" do
    url "https://github.com/libbitcoin/libbitcoin-protocol/archive/v3.5.0.tar.gz"
    sha256 "9deac6908489e2d59fb9f89c895c49b00e01902d5fdb661f67d4dbe45b22af76"
  end

  resource "libbitcoin-client" do
    url "https://github.com/libbitcoin/libbitcoin-client/archive/v3.5.0.tar.gz"
    sha256 "bafa26647f334ecad04fc4bbef507a1954d7e0682f07bd38b90ab66dba5fe0d2"
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
