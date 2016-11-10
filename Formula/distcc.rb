class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/archive/v3.2rc1.tar.gz"
  version "3.2rc1"
  sha256 "33e85981ff6afd94efc38b23b2d8b9036b3dff2dc6eac6982b9ff0ae1de64caa"

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  bottle do
    sha256 "67cace8962a3046e66c71726e0800b93635e2b51d5ae95d1a4465ec6c93e3a93" => :el_capitan
    sha256 "e2fb841415d554487d5cd7a9410862c08b99bde86d59e78d007b1eaf73173bdf" => :yosemite
    sha256 "bf0e1b9468861414802356814229c8c1256abf22fb00bc2819644f4f6e336485" => :mavericks
  end

  def install
    # Make sure python stuff is put into the Cellar.
    # --root triggers a bug and installs into HOMEBREW_PREFIX/lib/python2.7/site-packages instead of the Cellar.
    inreplace "Makefile.in", '--root="$$DESTDIR"', ""
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "distccd"

  def plist; <<-EOS.undent
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
