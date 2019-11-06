class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.4.4/bacula-9.4.4.tar.gz"
  sha256 "0fe37a02ca768a720099d0d03509c364aff2390c05544d663f4819f8e7fc20be"
  revision 1

  bottle do
    sha256 "7ff69bac02212b3e43d2dfacd2784447e7709d80fff81b554fa229c360d12704" => :catalina
    sha256 "26091f267000c57d27c038a05172c7249572f0ddfe1834a8eba154fe00c36b75" => :mojave
    sha256 "4353cbd80b6f4af021f4be1c6ff5b793a8530263c1c2307caaed962dc7ad9b11" => :high_sierra
    sha256 "707b08f95a9f5a200a6fdedb47fc9a80c25ebd88004606482ac5aa49ef72d1fa" => :sierra
  end

  depends_on "openssl@1.1"
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
