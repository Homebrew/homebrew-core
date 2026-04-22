class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.10.0.tar.gz"
  sha256 "b28d0c21535ff27300234a8c11ca08dceef9c33515a5842f362531bd70083083"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "e75ad66ee05e77f6aac6b6dc47a03989868067b4c1ed7b790e18b0ab92604379"
    sha256               arm64_sequoia: "d049a99186126a6cd72e03b2496a91fedecf409bdabb5261c384812184b6d59a"
    sha256               arm64_sonoma:  "9c2b74f769b586d036399bb3faeb7951aff2ba542a27eff01aa9568d1c89ce48"
    sha256 cellar: :any, sonoma:        "9b2c0e14f85a7cfc0c283c1f45a051e4678b8d04de44e38608d048d9a8061318"
    sha256               arm64_linux:   "a33de85dd32d11218e94d4912046cedafa75076812c21e9f3b5826eba18a071c"
    sha256               x86_64_linux:  "eeedf35c6481fcc4a5d7c674668fc402d0b95eb4d891f4e667659ad71e05c845"
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
