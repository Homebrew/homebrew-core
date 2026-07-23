class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.15.0.tar.gz"
  sha256 "1ba43dc3f2540001ce2d9e2b0cea1fbebd3271095ae1d0154108d13f3697fdd2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "f9ee5f440a2a2fd832caed46618f21b76b3c3150209886e28fd3cac45f78ee89"
    sha256               arm64_sequoia: "5e86a7c81e5d3c6066a16b2826a49bce90f31420ae31b1456481f79f446e4ff7"
    sha256               arm64_sonoma:  "9ac892c5b3f4829d239c62e218c16ef3d6b57b2099bdeacce651f3c56d2ca44f"
    sha256 cellar: :any, sonoma:        "e2308a4723fa87ad130784059c391826f58ab219aa09b978bd46a1a8a466f691"
    sha256               arm64_linux:   "68a65b06d3bdd1de7ac69642031be63b99e0f64684cb6f942d3c70f829129330"
    sha256               x86_64_linux:  "6e7ea58526d3af7522c46c7f8fd6faaf02002a630da6b616de61504ac52079ee"
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
