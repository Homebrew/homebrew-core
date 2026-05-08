class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.11.0.tar.gz"
  sha256 "81ff6a63a2dff7328af0fb3d39669fba608b7ca58ed48f225814ca7b98f5b6f7"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "958b9e75340283b80eb979913f0c6c8a0014e71ac60aee6dd30f2a1792f106f1"
    sha256               arm64_sequoia: "eaf8e02cc544acd58719ec72edacb2aa25b7f54bf31efab5d2a236fa95a1987c"
    sha256               arm64_sonoma:  "1422eaeb55fcc0f710e3ed7c94871428cfa3dbe52c0f336030d6b2125045f8f2"
    sha256 cellar: :any, sonoma:        "9eb1d3fd788ecf826d84962aa1aefb62d5ad0506d2d55f98b543a1bbf64d4a5a"
    sha256               arm64_linux:   "868313e96c75c896c2458f5eaae6e8c1bad329f136588601165607e61d7caf6c"
    sha256               x86_64_linux:  "33a6be0203a5d9036174c9b4b66199ed34fe252a28c353d3c2b7525449a9fa99"
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
