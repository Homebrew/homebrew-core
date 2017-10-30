class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.0.4/bacula-9.0.4.tar.gz"
  sha256 "cafa2d9a9e89a77d3b79984972487e72fb90d949269c77a74a68e97a9d28996f"

  bottle do
    sha256 "0a700c97b50c3e69db6e21cdbcb0e7d86118a878368768073bed3d38071c95b8" => :high_sierra
    sha256 "725d7cfea18a08afae8bb22fbe4da5cc0496b712ff212e351b63bd58b91c1fd0" => :sierra
    sha256 "c48c7d7e31183ff2a035c8f0558cb373a1a89b4c41ae7a1a4188c4adcf75c2c8" => :el_capitan
    sha256 "1b7a60b6813c519491d693e4fa44a8f6f26ad06683a314dd0748c0d5197fc57c" => :yosemite
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
