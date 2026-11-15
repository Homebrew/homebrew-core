class ClawsMail < Formula
  desc "User-friendly, lightweight, and fast email client"
  homepage "https://www.claws-mail.org/"
  url "https://www.claws-mail.org/releases/claws-mail-4.4.0.tar.gz"
  sha256 "642d78309b7b153699c417bcfdf505a735b19c57fd731a0bbb5752ad6adbdb52"
  license "GPL-3.0-or-later"
  revision 3

  livecheck do
    url "https://www.claws-mail.org/releases.php"
    regex(/href=.*?claws-mail[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "d9db5bd0175507711b16baace6f219a88d1f763673f245a53f889afe18e9055f"
    sha256 arm64_tahoe:       "2b44bc7b150fb7a1300c1b349215b3ebf27cef545eab1ebf39293cec0111899a"
    sha256 arm64_sequoia:     "95a87435b43c6b8620f5d6c4af4a882d765c1f4248338f2be61d589866eee6af"
    sha256 arm64_linux:       "0df7c59a820265bdbc44cc4c560894374a22647360c6945766b9aa8177f562cf"
    sha256 x86_64_linux:      "184237a3cc59c2084d4148ae844cbfb6dbe0ca986252700988773b8e4076a60c"
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
