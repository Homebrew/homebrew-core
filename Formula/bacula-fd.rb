class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.5/bacula-11.0.5.tar.gz"
  sha256 "ef5b3b67810442201b80dc1d47ccef77b5ed378fe1285406f3a73401b6e8111a"

  bottle do
    sha256 arm64_big_sur: "870ed54211752a2b5074b4541d7e20a07f7cfc5823b6b4ca02754714664a41a5"
    sha256 big_sur:       "97a132f840f80286105c4053a9278840c3b87759f9fda275d17b7e21b229b2ee"
    sha256 catalina:      "fe0716a5da8e44667f410c60b426fa3367b3086e1da3802120d46e0f2798de85"
    sha256 mojave:        "df8ff109522a1091ab1838926142023f5c0119475c8757d5134149442ee1b610"
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
