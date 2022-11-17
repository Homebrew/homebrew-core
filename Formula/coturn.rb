class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.0.tar.gz"
  sha256 "42206be7696014920dbe0ce309c602283ba71275eff51062e5456370fbacb863"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "http://turnserver.open-sys.org/downloads/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_ventura:  "eb2f2f7510a4b50df4e3e7428a8daca052b6450a872eb1f62293e9aedea65b8b"
    sha256 arm64_monterey: "05ed1d26deb23be08ef663b1fe3f6b12d3c2b12446b602bf32da22bd35cbbcc9"
    sha256 arm64_big_sur:  "8442d032bb086f804d0ecf9af43b35514406560b37f87f66a233452daf304ca5"
    sha256 monterey:       "1dcb943114d883f153c817085c806fdb4310fe83df506fd0f9f439b524463d1a"
    sha256 big_sur:        "42a300446b36f922639fcd7a767257fcf77db52bdd3d20869174ee8ecc456654"
    sha256 catalina:       "07d0a45f2a2c9561bae382d6febaedf79d230d10006d4c98e9cc5d85d1b236bb"
    sha256 x86_64_linux:   "488f33b229882b58422fdad05e8aa5b96e5db6b68bcc6b630e3e25edc9488a82"
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
