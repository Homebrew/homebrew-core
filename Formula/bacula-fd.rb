class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.2.0/bacula-9.2.0.tar.gz"
  sha256 "df6bc7d81dbfe218ee58f9088dc031fce76e0c2e265126646f72ed32610456c7"
  revision 1

  bottle do
    sha256 "0caea93b38810c1b73a262145db3d12565f6f13d49cef4e73c5e39d72c413178" => :mojave
    sha256 "e5721a004aa365ad12c53c4cb593261ba9e2c809d877480a9efd98d2c6986e73" => :high_sierra
    sha256 "f4b1f49978b3a4b5082a7514ee4995397e3c40768f6a87f460f262c92805cb96" => :sierra
    sha256 "cf30893eb978f8da240416e6bcece5154caf59ecc70afb1d8217cf18ffb9421b" => :el_capitan
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
