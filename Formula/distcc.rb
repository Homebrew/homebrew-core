class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/archive/v3.2rc1.tar.gz"
  sha256 "33e85981ff6afd94efc38b23b2d8b9036b3dff2dc6eac6982b9ff0ae1de64caa"
  head "https://github.com/distcc/distcc.git"

  bottle do
    rebuild 1
    sha256 "73e68824284081284a7a155fcee8343affa3e74c5758928cf35e6451f3170359" => :high_sierra
    sha256 "7550914e05bccc38cf002ae14a2209248166149fa2720f0b8716320433d51c28" => :sierra
    sha256 "7a457a41b795c825e315a296e6883a8b8ab749f8329d492026f4b9072571dc7b" => :el_capitan
    sha256 "4b38fccd7d1f3ac119bc50f4252fd593a828a6564dfb98d6bc819adff332a4b5" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', ""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "distccd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_prefix}/bin/distccd</string>
            <string>--daemon</string>
            <string>--no-detach</string>
            <string>--allow=192.168.0.1/24</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/distcc", "--version"
  end
end
