class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.3.0.tar.gz"
  sha256 "24a4d024c36f98add0e0b935cfa03cc6df01bc1b3f479a7a9d6df57705b04b2f"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "eb436dc59303f44da3ab375d860a40a778ca8c42cf9433d3154de49a1155a5df"
    sha256 arm64_sonoma:  "56ee41c9c2477cee478bb0ee5af18780c54b430ef4277630d98399a015fab8af"
    sha256 arm64_ventura: "4da3da8b0fa9a94f764ff5729ccefe866bd2e2cdd37900a46d596b3b607468e0"
    sha256 sonoma:        "defbe49f59b83d9d7dddd419ce018c6d3e40b0f57d3df3b5e2f8022fa6a9238e"
    sha256 ventura:       "1c35e345b1267be409074f4d15c18a5cd94fed8eb315e640528928bb635afd72"
    sha256 x86_64_linux:  "6d08c23e20dc8679ed712a4709e976bbd722d7e0030114e43e322c88c0b39356"
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "nettle"
  depends_on "pango"

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
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
