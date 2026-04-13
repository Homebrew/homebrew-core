class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.9.0.tar.gz"
  sha256 "e01c0701792231d67768e0e314ebad6395501759ea56772dc7e36d3badec5549"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "e1bc1cd5d0a26a528e51ffce5f780106f91851b2256ddc3524acd3f7e37d49fc"
    sha256                               arm64_sequoia: "9ac2525f1551dbf51574b89d307607340b2c5b8de355ba1ee1b4077e0ff9d853"
    sha256                               arm64_sonoma:  "f4caf7856ffc1f1fc627898dd6152971d88525b9dd8ee76a2ce402a816322055"
    sha256 cellar: :any,                 sonoma:        "57898556ba6dd2ca2db060c21638a87f836dfdec414305cd1b9bc3e871aceab2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcbf83817ad6bb9f5877771e1e428fc092dd984c8ef4bc4dd3452b9c3742b64c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba12ae36102a8e832e27a97fc93c085071a1296e77d1fef465d18821f4771683"
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
