class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.5/bacula-11.0.5.tar.gz"
  sha256 "ef5b3b67810442201b80dc1d47ccef77b5ed378fe1285406f3a73401b6e8111a"

  bottle do
    sha256 arm64_big_sur: "90c424f536aadb83c4532a7b32c2e1e63d3fb1bafc561b9746cfbc27cda3a39e"
    sha256 big_sur:       "0912e3a6669920a1935bb6d2fc9eebd610277ce3b2917db4558ca18fb14109bd"
    sha256 catalina:      "9d66cc373192f4c50a9a4c22a0cd162c7ce57604d7e89c95197a13e64a7b2973"
    sha256 mojave:        "6e21aa8aa033bf0393ce813ebd77890f3ad1b9e68ca58990d6177b219ddd6d71"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  conflicts_with "bareos-client",
    because: "both install a `bconsole` executable"

  def install
    # CoreFoundation is also used alongside IOKit
    inreplace "configure", '"-framework IOKit"',
                           '"-framework IOKit -framework CoreFoundation"'

    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{var}/run",
                          "--with-logdir=#{var}/log/bacula",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{Formula["readline"].opt_prefix}"

    system "make"
    system "make", "install"

    # Avoid references to the Homebrew shims directory
    on_macos do
      inreplace Dir[prefix/"etc/bacula_config"],
                HOMEBREW_SHIMS_PATH/"mac/super/", ""
    end
    on_linux do
      inreplace Dir[prefix/"etc/bacula_config"],
                HOMEBREW_SHIMS_PATH/"linux/super/", ""
    end

    (var/"lib/bacula").mkpath
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options startup: true
  service do
    run [opt_bin/"bacula-fd", "-f"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
