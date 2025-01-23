class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.6.3.tar.gz"
  sha256 "dc3a529fd9956dc8771752a7169c5ad4c18b9deef3ec96049de30fabf1637704"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_sequoia: "cc1e87b2bd8ea182e22a581153ddc693dd38ac1f15fc0e463fcd154bd3eee57c"
    sha256                               arm64_sonoma:  "341e8ef28b555221b0511e20e7265d41d2dbefb1f0e8c289d914aa8e4725ef8b"
    sha256                               arm64_ventura: "ce340904c0e8031987effce0e9806806d633929d718f1be50bc535e7815549cc"
    sha256                               sonoma:        "46fcb4c3078988a2182c214ff9a3d1789f65003a877729ba8371cbc464ad495f"
    sha256                               ventura:       "14664b015f3e3d9842b5ee261a5d56a9685edd37be0712c59ee82a5df950f5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14cb601252934f11e56bf2be311806d9031745ad2b6cb22c2d4daf9244daa1d7"
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
