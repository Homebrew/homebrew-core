class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.18.0.tar.gz"
  sha256 "28d55294ac596fbd129b293a85e7bb1c5dc4bd15b7fb55c500f355149e5f4e28"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "9df190b12d0f6fa96502cb4479c63642cbc503efce74cb4f2443da00efa2b913"
    sha256 arm64_tahoe:       "3ea90ccd1c0543554533ebc49c2c31c57b529949c81614b9438707ba47a4b442"
    sha256 arm64_sequoia:     "902078b63e96cde7ceb87f01c312691ffb7aa554ff1423825976e6e173ef0ef5"
    sha256 arm64_linux:       "73c0a714385eb5f96b407191e3cf01d4c38541fbba63301e077583bf949076ca"
    sha256 x86_64_linux:      "0242aca0eb1e6ce68e5350b1eeed62177d594bfc9dd217794d865516cbfdff6b"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  def install
    ENV["SSL_CFLAGS"] = "-I#{formula_opt_include("openssl@4")}"
    ENV["SSL_LIBS"] = "-L#{formula_opt_lib("openssl@4")} -lssl -lcrypto"
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
