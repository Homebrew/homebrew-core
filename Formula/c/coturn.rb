class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.3.tar.gz"
  sha256 "dc3a529fd9956dc8771752a7169c5ad4c18b9deef3ec96049de30fabf1637704"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "d9bc46fa338fa68b9a829f2086b359e2cd92291ac2334d23d2d25bce73210647"
    sha256                               arm64_sonoma:  "f48367d4e77f52c69ab4ad0276a3b8f8200679e8dfcb5ac5995dfa0603454778"
    sha256                               arm64_ventura: "177e302f3af1048a929dafbdd0ee76c11f94d37fa5463b38e29ee3967c02d099"
    sha256                               sonoma:        "94d3da45859fbc4ff34196fba84e0af037a9654efe84e5656f2287b22808ca25"
    sha256                               ventura:       "de095f3b7f5020ba028b1b01aa6750400e395f1a87c6c6d89748d07b5dcf5250"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64207317fa171d91d0088b4d8cc9f97de409735a2343b18b6a724489d6fd9edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "231c71724dd5e78c2373cbc3e145b30552e36663ae210c305f2935d025681982"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  def install
    ENV["SSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"
    ENV["SSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib} -lssl -lcrypto"
    system "./configure", "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--localstatedir=#{var}",
                          "--includedir=#{include}",
                          "--docdir=#{doc}",
                          *std_configure_args

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
    system bin/"turnadmin", "-l"
  end
end
