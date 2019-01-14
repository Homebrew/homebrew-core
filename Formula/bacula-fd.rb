class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.2.0/bacula-9.2.0.tar.gz"
  sha256 "df6bc7d81dbfe218ee58f9088dc031fce76e0c2e265126646f72ed32610456c7"
  revision 1

  bottle do
    sha256 "1203c3f94bad96756d94dfbfcad52c9a1e45d574a4ef49357f57a75ee964c421" => :mojave
    sha256 "9535d7e258021a724b6dfa7b48cef870b52f41edae2175386b6e1b58a6cabb87" => :high_sierra
    sha256 "f9d7ba8ef75dbfc767ec209a488b2cbe05a3f7e30ad0d4759c7b9cafeef929fd" => :sierra
  end

  depends_on "openssl"
  depends_on "readline"

  conflicts_with "bareos-client",
    :because => "Both install a `bconsole` executable."

  def install
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

    (var/"lib/bacula").mkpath
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :startup => true, :manual => "bacula-fd"

  def plist; <<~EOS
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
