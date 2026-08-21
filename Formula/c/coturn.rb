class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.17.2.tar.gz"
  sha256 "645a1beaeeba2684139d9b342d30320ac57a415577b6356dad9df20025cf5315"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "a10c093d03a416a56bae9263b6d6893c789e318a727d417a273e7d5114c9f145"
    sha256               arm64_sequoia: "4c60869d1258268bce5a08fcc6b1c8fcbbb0d16d92ed6105aaf8729e6cd0d9e9"
    sha256               arm64_sonoma:  "88786774d6c275a9549805c07d18a1a0124a1cf0413596ef0f26cffe2c48c352"
    sha256 cellar: :any, sonoma:        "ffc01cb8524b0edf21112c82357c68f30b7f54ed7b5bbb5f75a2aca3588bf5ce"
    sha256               arm64_linux:   "224a402b1649fa4df1948cf1c795037f0a0f6e871da1f4b367e107cc0f33468f"
    sha256               x86_64_linux:  "686dbfd99af8c408c17f5d03b96aecb374c7f5e04ecd930246308ed4695029f9"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{formula_opt_include("openssl@3")}"
    ENV["SSL_LIBS"] = "-L#{formula_opt_lib("openssl@3")} -lssl -lcrypto"
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
