class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ee1ac3be93f73c8b809260179278f32cc6f63b00fca95f6ca09ca18e4677d767"
    sha256 arm64_sequoia: "5beef6e43f8e3f4885bc1d4077f3f9c9db320de47d0a3b61e4d1ab521718f614"
    sha256 arm64_sonoma:  "92def14333cf5bde9b257e81f0ac9b57624ce741f5497c3e6eed46db15dc5aff"
    sha256 sonoma:        "b22559fa49882eab1369c6207ce4324befb9ef44bcd9e351f99460914687b523"
    sha256 arm64_linux:   "94e0b5594e366b508cc5df0cd9870a213b0b7638666177e745bb721c3c762b96"
    sha256 x86_64_linux:  "84a791186ecf813562c124919d45dae96fdf0ea0f5b372a9f1b861854a544577"
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
