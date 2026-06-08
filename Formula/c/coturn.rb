class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.12.0.tar.gz"
  sha256 "5374811d50548e2eb1982c0591a55c79c95d78633c17fd211bef13206087e95b"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "9cf357e8caad6be024bcac03a154593d2cd1fbe6ddf3a21ad4f0f523f63fe6dc"
    sha256               arm64_sequoia: "71485f44877fa22abff04700d592bda04b1cef2477c90ac89356c89a81394461"
    sha256               arm64_sonoma:  "067e71d860f38c8a43649f015bba0349e63b031a073b5455208bee1b679bc054"
    sha256 cellar: :any, sonoma:        "29d8af1327a8af75c1833f19f9d891dfd014bfb350cc327f6c0966cbd7a8854b"
    sha256               arm64_linux:   "391b73f312f4f18ccacab665c588806729065caea49258791bf59edb4c3d1c27"
    sha256               x86_64_linux:  "f70af247288665d50e305f2303f8e593e7827b9fdaa9b668b2c5a5ce1158b1f8"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

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
