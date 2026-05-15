class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "6831e9be76de893a5d79834b3822145fd085a3c44c8a5e65d9b7e4969a51a3a9"
    sha256 arm64_sequoia: "dda17bbeb1dc14d1473f6dd19c4d20b22a17b0d7253c53fbd810bf8461d32c51"
    sha256 arm64_sonoma:  "e0bd89dc66d75a171cc1237e852184ebcd4e77fac035055990b8b6e61cb1e9e8"
    sha256 sonoma:        "d990f303124905661817b91f64b5273ba14fa62e6bdcf4bd0de2b18bddb97535"
    sha256 arm64_linux:   "6a0866128ab5395b64c9a7cdffbc72dbe87c481b525b5447763c3351576e1cf0"
    sha256 x86_64_linux:  "3c507d478e0d9609d483bfcbddda06b57f1cc48910766dd73cf577488a1a4fa9"
  end

  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "zlib-ng-compat"
  end

  def install
    if OS.mac?
      ENV["LIBETPAN_CFLAGS"] = "-I#{Formula["libetpan"].opt_include}"
      ENV["LIBETPAN_LIBS"] = "-F#{Formula["libetpan"].opt_frameworks} -framework libetpan"
    end
    system "./configure", "--disable-silent-rules",
                          "--disable-archive-plugin",
                          "--disable-dillo-plugin",
                          "--disable-notification-plugin",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_equal ".claws-mail", shell_output("#{bin}/claws-mail --config-dir").strip
  end
end
