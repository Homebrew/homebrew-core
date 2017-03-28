class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.4.7/bacula-7.4.7.tar.gz"
  sha256 "6f6075c2ca90a63cdeeca39b0b82a3ea07ce9999dedc68951d88bed7fbc0be40"

  bottle do
    sha256 "12680dc5b7b9bdf21ae537170e4d31afa879b656e7b4b9f2f2897276282c7adf" => :sierra
    sha256 "e1abdf828517786e6c737e637b1672f40aa14fbe999eefaf54359810530991fd" => :el_capitan
    sha256 "6a0e3256e4db2f79f35137bd570e5804200d9af4cc03532f9abdb52b8a4b2b33" => :yosemite
  end

  depends_on "readline"
  depends_on "openssl"

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

  def plist; <<-EOS.undent
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
