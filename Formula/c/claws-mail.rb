class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"
  revision 4

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    manifest_sha256 "9bb4beb276234884c9697727f6c1ecc2bdf32d96f2f875bbec082141e4944439"
    sha256 arm64_golden_gate: "e076d4f08bff2c997f6490029f7695cf1e2967b18da56109bbad319d59544c69"
    sha256 arm64_tahoe:       "55b8e98959b2f53646bcb490d21c035684eb423f79077f237baddc8d7d49c379"
    sha256 arm64_sequoia:     "43e50c2070c1ce7272b19017b2a5dde3eb84d18d706ddd7a17a9e5e6a2bd8beb"
    sha256 arm64_linux:       "a660bec2a731ec56ca2901c8e1721f340804ad1b3734851eff87859bcdcc1dc1"
    sha256 x86_64_linux:      "983e45268e00c0937754cc663969d9f162dc0dba97a68e22d6325547b1bafe23"
  end

  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme" => :no_linkage
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gtk+3"
  depends_on "libetpan"
  depends_on "librsvg"
  depends_on "nettle"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libice"
    depends_on "libsm"
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    # Reduce overlinking
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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
