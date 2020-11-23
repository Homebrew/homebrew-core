class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.6.6/bacula-9.6.6.tar.gz"
  sha256 "6286c975e3f4980c1b4b3bc81ab9cda9186708eb19515abe4dc0b9ed5e2c8281"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "93e80a00345e656f521e24fd8f20cf96412b12c13de03a519d560aa20e55a5e6" => :big_sur
    sha256 "0dd869846330eeec14fdf2c4c4fb4c68366f436a541d15c2ffb5cce2184b7d68" => :catalina
    sha256 "835731f3c18291b5dc2d30cd55040e0b1fa349d00e83a8fa4c7a1de85e974c50" => :mojave
    sha256 "6283f63974c24309a3219b6952b43f30fdc91cc6776305a240e5970320c76e39" => :high_sierra
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
