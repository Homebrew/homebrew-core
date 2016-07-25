class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.4.3/bacula-7.4.3.tar.gz"
  sha256 "597db51997fcdb4c8bdc201f2dc22b466e69152bc2945e2222a27f4ffaeba5bc"

  bottle do
    sha256 "c4d151638573421aebb24af923adeb5fe84bcf64ed15f336def4581e04520d20" => :el_capitan
    sha256 "92b170b3501e97979f17ae15a40574454178112b80b6044ea79b9fcf51b73634" => :yosemite
    sha256 "fd770a2d7ccd6f687bc7d40c046b37bbe83011b726581717fd05711366381f09" => :mavericks
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
