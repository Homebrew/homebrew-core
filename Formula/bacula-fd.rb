class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.4.2/bacula-9.4.2.tar.gz"
  sha256 "a40d04d2c48135972cecb6578405e835c4b9d798c0950017de0fad40ca94e8a0"

  bottle do
    rebuild 1
    sha256 "33f9f06b2a81546cd7b23847fc1753d8b2c04555790008cb80a04a36c6f1eb06" => :mojave
    sha256 "884786124d1a64aa5991b22ec4339253c4fa0ccf1eb3d0ad99c2b98118a9b5d1" => :high_sierra
    sha256 "e9ef458c0c3d0b35d944d12104625c932ad63ea158fb1c06e092350579c44c80" => :sierra
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
