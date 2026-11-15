class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.19.0.tar.gz"
  sha256 "988b0090f6f30782a7e19c974a9d85cbd70cc1cd4788d21c4361bc2603dbc13d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "6ef92bc8a564d8a61d18468a92c665f2718de585fb3b2a962015ec8bdd01081a"
    sha256 arm64_tahoe:       "9178ec71cf0ce450b326101577e2027bcd0a55d2df060b49442745c47af6e144"
    sha256 arm64_sequoia:     "81f67977382b1d636fe4040914d1ddf432c3898b38a2a0dbb7ac045d98dde372"
    sha256 arm64_linux:       "a54b2145422b5021dd73f1805a79a9762d37311981b8dafc8c80df25f1108f8f"
    sha256 x86_64_linux:      "1fbc2a37abb2ea7d535ffa962028172599f15ab00ae3b24ccc70379f44f86021"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  deny_network_access!

  def openssl = deps.map(&:name).find { |d| d.match?(/^openssl(@\d+(\.\d+)*)?$/) }

  def install
    ENV["SSL_CFLAGS"] = "-I#{formula_opt_include(openssl)}"
    ENV["SSL_LIBS"] = "-L#{formula_opt_lib(openssl)} -lssl -lcrypto"
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
