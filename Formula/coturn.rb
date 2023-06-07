class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.2.tar.gz"
  sha256 "13f2a38b66cffb73d86b5ed24acba4e1371d738d758a6039e3a18f0c84c176ad"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "ccfc967fa50ea4a44c5afa39a766d76c4ad4642b0b0816360f31073bd2d2b48a"
    sha256                               arm64_monterey: "e61a8f61698a7c219d4ccab689aa4f8cf7770679c4d620383447fb16e091dd92"
    sha256                               arm64_big_sur:  "4cdb0da4161adbdd9550f5873f0b61f0007a1db3714f59bea82be2d29fc5ae94"
    sha256                               ventura:        "89bf30786ce50cccd1e87cdc48e4a723a22b172bd17892e6fe3bb967da8130fc"
    sha256                               monterey:       "5ecf51760ebf6d83069f7951bce5e7dbc6abbf77b0b7124310dfa14afeb3837b"
    sha256                               big_sur:        "b63f52f5b0d1b1dde6ed412294c22a91b3e916cc2d8dfaaa52abd1452688db89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f2398fe6d68335ff161675f62eccd2178da9e78f602be5a8a2810e44625bbbf"
  end

  depends_on "pkg-config" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--libdir=#{lib}",
                          "--docdir=#{doc}",
                          "--prefix=#{prefix}"

    system "make", "install"

    man.mkpath
    man1.install Dir["man/man1/*"]
  end

  service do
    run [opt_bin/"turnserver", "-c", etc/"turnserver.conf"]
    keep_alive true
    error_log_path var/"log/coturn.log"
    log_path var/"log/coturn.log"
    working_dir HOMEBREW_PREFIX
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
