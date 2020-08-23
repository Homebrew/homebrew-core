class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.6.5/bacula-9.6.5.tar.gz"
  sha256 "510f35b86138472abe6c559caded7bc773bf5eb1b9ee10905ee8f4f827c7c77a"

  bottle do
    sha256 "9f60d58bc6f3709d3ed3fabb03a82d9197a76a4f8bea6f0b4d5cef24bec5e5ea" => :catalina
    sha256 "af55545e264e8fb2b7b0ce417194d7d27ddb17d41d28e9664c8e9371164958d0" => :mojave
    sha256 "a615488f494959d4d19cee5d863c4c306a2180ceab548742c93cef68fe8b688c" => :high_sierra
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
    inreplace Dir[prefix/"etc/bacula_config"],
              HOMEBREW_SHIMS_PATH/"mac/super/", ""

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
