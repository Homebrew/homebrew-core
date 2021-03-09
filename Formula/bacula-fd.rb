class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/11.0.1/bacula-11.0.1.tar.gz"
  sha256 "2ebd9cdb885953c03f09df31180eeb7ea81aebb821cf45c9fdcb3fcff85294f5"

  bottle do
    sha256 big_sur:  "1ad2a0eeb9c13b399ffcb571eedb60b2f93344a3fdd57f62df597348937ecfc7"
    sha256 catalina: "4d94df8a15262db66b97b7cf230f6b99db3ee607fdb8b12451f1d3fc75f308e3"
    sha256 mojave:   "6579ca5a2472fb6171853ea3e9eec81481d3d9c36a0624a629199febf73cbadf"
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

  plist_options startup: true, manual: "bacula-fd"

  def plist
    <<~EOS
      <?xml version="0.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/bacula-fd</string>
            <string>-f</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
