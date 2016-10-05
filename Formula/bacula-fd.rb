class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.4.4/bacula-7.4.4.tar.gz"
  sha256 "01a53d4501b17aeea0c25f0b63e49b4586ac221107834a6c471c43bc602c4c47"
  revision 1

  bottle do
    sha256 "35760de4ee5391c603cf504c406d73ceaeb1193801a4560b8a7ca56fb36e1ad6" => :sierra
    sha256 "b5c52055f4c7dc723fe4e329581cd31dc6dcfd0445c58013e1b27f5b71ae0f1a" => :el_capitan
    sha256 "3039e27103df2b250ac356f28e0c1effc1f873fb79fdbe749c79c51f2d946c90" => :yosemite
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
