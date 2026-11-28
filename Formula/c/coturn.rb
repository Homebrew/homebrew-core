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
    manifest_sha256 "522af09f4ab94bbd91b4a60332d239ad23ab91258380a0ffb1824631105dc50a"
    sha256 arm64_golden_gate: "382858b794737f8ca159c4ea3685cd83ec69367a9281cea4dac30ba37012a2cf"
    sha256 arm64_tahoe:       "7dbe6c2b8f06f074beec4322e65f38fb5ebc85ef09276c3b45498bb129e414f9"
    sha256 arm64_sequoia:     "868c6a3dd7923e64f8aa44aa8dd77669c0f47cdc32d332c1cfd72981e3f60524"
    sha256 arm64_linux:       "74ada9eab70f6dcdb2f9c22c85ff459b262d8618acc016e65c736a4e48bd95a1"
    sha256 x86_64_linux:      "781f5489062daf3c12d13a994e0b568b1badc931d095782c267607cb4f7cb672"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  deny_network_access!

  def install
    openssl = dep("openssl")
    ENV["SSL_CFLAGS"] = "-I#{openssl.opt_include}"
    ENV["SSL_LIBS"] = "-L#{openssl.opt_lib} -lssl -lcrypto"
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
