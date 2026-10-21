class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.18.0.tar.gz"
  sha256 "28d55294ac596fbd129b293a85e7bb1c5dc4bd15b7fb55c500f355149e5f4e28"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_golden_gate: "71e97601ccf89f74388f5d4814aba56ca90311220ef0568e3e72ea6de975ea83"
    sha256 arm64_tahoe:       "4c2cb1d8f0a6c9676f651faef2e33b229b1d7921c2f983e297cd3fde2ed281d7"
    sha256 arm64_sequoia:     "69f8a4cf97efda24c1767636600e3b878cfbd02f47c51b2ca09b94cb915bf3a6"
    sha256 arm64_linux:       "a9bd7e210909fa8cf75f96a313f01ad90622c06a27d96e7474c9879e3c82b8db"
    sha256 x86_64_linux:      "708eb4814d939879c12f3d969250c94c13a38a6839969c4284e47c3792bc9370"
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
