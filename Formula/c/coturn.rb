class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.19.2.tar.gz"
  sha256 "2c80e4dffd0eb410951ba469f5cf8bd9b4a0658afc72d816f5c519c0c988d75c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f05fd7665cd7c4180ed2f328a834f5d3383f5909f0d154d524d29b31f8c62d45"
    sha256 arm64_tahoe:       "361d806f94ceb0969adf09770e514783c079e54fd3585279ecad36d7ee17bd5f"
    sha256 arm64_sequoia:     "e3ef428334a846d74fac44a0f36993c46d12e16799140310a524b56fc2232d8b"
    sha256 arm64_linux:       "944a4d1bf27296f1331551bbcf250d99bb4adf9de8f7203564218b0c20c460e9"
    sha256 x86_64_linux:      "2addc3c528789d8e84aa27cb5c7fee093d38147293bf359fe35ab80cb38e54f9"
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
