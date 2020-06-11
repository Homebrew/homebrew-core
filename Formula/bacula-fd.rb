class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.6.5/bacula-9.6.5.tar.gz"
  sha256 "510f35b86138472abe6c559caded7bc773bf5eb1b9ee10905ee8f4f827c7c77a"

  bottle do
    sha256 "582fafcb8a0f9f483a94cf124a03f88be86f34cc94739efbc2624002ba25c4fc" => :catalina
    sha256 "c4785c8a422d053a7a65892748c22283dc2f61b8a8c1512e61c2a0a0911da80e" => :mojave
    sha256 "897dbcb7fef86658445edd6e6e8a2327157ff0dc1467ac527a905e19e2eccb50" => :high_sierra
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  uses_from_macos "zlib"

  conflicts_with "bareos-client",
    :because => "Both install a `bconsole` executable."

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
    inreplace Dir[prefix/"etc/bacula_config"],
              HOMEBREW_SHIMS_PATH/"mac/super/", ""

    (var/"lib/bacula").mkpath
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :startup => true, :manual => "bacula-fd"

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
