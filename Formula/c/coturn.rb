class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.2.tar.gz"
  sha256 "13f2a38b66cffb73d86b5ed24acba4e1371d738d758a6039e3a18f0c84c176ad"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia:  "f7c39ae1c05a2070ae697a9faa8eb6eb0a12c49369156c6113e5b285a678a371"
    sha256                               arm64_sonoma:   "bc53417a3443680592e2fdea9159781f7c8fb5ea7ec7be327fd9df6987fadf83"
    sha256                               arm64_ventura:  "29aca0c706485a911b2a21de41235d9b592919508585d626425709518e30a9ea"
    sha256                               arm64_monterey: "618cbd141e1e439b749b24147e26c49d1d75da27009f565ce03040c73d24d559"
    sha256                               arm64_big_sur:  "aab53a999e6e1b0ad15a3b9db8f3b34d8cb0d1ae66c7d9f2977f5b898468d42e"
    sha256                               sonoma:         "bc5acd8521bc434c57ce6f4c7f50355bc9c1630737373df5a1c167e87acfc13c"
    sha256                               ventura:        "64b12f1d41901b80b75fb1d36f443864b51df41a31dc71eafb007dbdfd8cab20"
    sha256                               monterey:       "5a032a4fa80f86dc196db3363c7d2afcd0a622c2adbb6d3fc0eb294b04d56554"
    sha256                               big_sur:        "96ef0109d26469de93155a60f49a2fca01c64b02267f45d89a7102aff069392f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c91fbd01d98f9d930e27333818de9f7ae357b1d0ca2313a8a6fcf1f4eee8837"
  end

  depends_on "pkg-config" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  def install
    ENV["SSL_CFLAGS"] = "-I#{Formula["openssl@3"].opt_include}"
    ENV["SSL_LIBS"] = "-L#{Formula["openssl@3"].opt_lib} -lssl -lcrypto"
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
    system bin/"turnadmin", "-l"
  end
end
