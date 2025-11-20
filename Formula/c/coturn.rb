class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "https://github.com/coturn/coturn/archive/refs/tags/4.7.0.tar.gz"
  sha256 "adbc90550d326e1b0fef4ccf9955c0ea32e63792acedcbc9cdbe9f71f380e622"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256                               arm64_tahoe:   "a2aed13b2bfe94023e08c3071184104c18fe5d3a991d8d6fd0421e565ee85ee1"
    sha256                               arm64_sequoia: "fa977d739b4f45c90e117848b494943dc4c5862d4f7dca2eec9329b5f98ea1b7"
    sha256                               arm64_sonoma:  "ef170c3be32ccca9f426c5ee91f2f1b2d6b23eab2d14b61a9dbef90634b3c184"
    sha256                               arm64_ventura: "370b0e1c912d181a353d10d5f809bb929a7ee62efd4e4b256f93be4d5f3ef8b2"
    sha256                               sonoma:        "dfcd872aa3063d9c3fe48429a3eb0db83244f5c489133d58d019c0aaaf7e67f4"
    sha256                               ventura:       "ca058c6f5813d62c5c96ee2a530f2af73788e1906f06c4dc8cebad1503d977e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38bb0504053fe35dc664db2c484db9490abe48835b14f90742240b3eafcc419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f113db4b6046a08adfa26a0602d4a3855d6fef9f75958a0039a5778e7594aa12"
  end

  depends_on "pkgconf" => :build
  depends_on "hiredis"
  depends_on "libevent"
  depends_on "libpq"
  depends_on "openssl@3"

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
