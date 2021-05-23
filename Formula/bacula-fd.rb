class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.3/bacula-11.0.3.tar.gz"
  sha256 "01587734f7490fcb7737801b2e1fe1b1f94707bb3fb0b71b36713c7aab03923c"

  bottle do
    sha256 arm64_big_sur: "331f1ea1e1a5f169bf50acaeec46c2f2fc71324c3ba30fa40ff6b0d74653a021"
    sha256 big_sur:       "5e9cfba07ac1ce2145c53f8ef7a55314ec3225ecdbb75d3b783a5283ae7618f7"
    sha256 catalina:      "66280b36a3b7c7dd2c9df396ee078934f79b0756389d95e85fec149580c18ca9"
    sha256 mojave:        "fc6487297bd56ab45332baf9ee48dc11926d2bdb5efe429fd89111218dcf7dbb"
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
