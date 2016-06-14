class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.4.1/bacula-7.4.1.tar.gz"
  sha256 "d0874e94c0534274455efd91d6f9477c57c7f14882138f03b3572eff2660e861"

  bottle do
    sha256 "4442ef7ae75951cf59f07dec86638799e8905ddcfc1384f917656a85acfaf703" => :el_capitan
    sha256 "9fe5f23706dd4ba5f9654f71a80fce372b296247fb560aaa1b4334d3a9020adf" => :yosemite
    sha256 "88f23b78925f81db0b64ae60aaccbad872efbb133041b627effeba048c55df35" => :mavericks
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    readline = Formula["readline"].opt_prefix
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--with-logdir=#{var}/log/bacula",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{readline}"

    system "make"
    system "make", "install"

    # Ensure var/run exists:
    (var + "run").mkpath

    # Create the working directory:
    (var + "lib/bacula").mkpath
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
        <key>UserName</key>
        <string>root</string>
      </dict>
    </plist>
  EOS
  end
end
