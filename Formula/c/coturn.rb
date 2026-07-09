class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.14.0.tar.gz"
  sha256 "dc575988326274eb46256b04ef8dad698df8c8e053a35d9e5596fa8f2208bf81"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_tahoe:   "b90c9fd721b405bbcfbd358d9da472bbe83431c6ee8e93d9f8000b2908d4a52e"
    sha256               arm64_sequoia: "d4bf9ad40d31961727d1e5055262b4ba127d25b68351bf13ffcb3090d0c8bd8b"
    sha256               arm64_sonoma:  "0f13667d3c84406a91d8168bf917405230baaccae41b04ba736bd15156c48162"
    sha256 cellar: :any, sonoma:        "09a0ce2021a65cef72511e2985447d86ff75432a279e59506e25c700d402ac1a"
    sha256               arm64_linux:   "3fcb3203eb5d36e13dc3f93a2f40c663845ea8efc2b4f52b7cb696451e2c8cff"
    sha256               x86_64_linux:  "082af85c9de6e78350e2539a5cc2ce4cd0e0e637b1863f88d7933a0491f25910"
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
