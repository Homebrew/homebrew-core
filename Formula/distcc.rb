class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.2rc1.2/distcc-3.2rc1.2.tar.gz"
  version "3.2rc1.2"
  sha256 "7199806c5bbd7652e2d10989965afc7411c4e47bd5a1a621b3633b24e3a21444"
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "cf2e6cc5314246ba6946434e7a8670817355dfdb3830366b3869a51fb026ea60" => :high_sierra
    sha256 "61d32816afc78eb43e58428d26fb3cf25f1f540cb529c3f1c645fc455c99fa3f" => :sierra
    sha256 "cdc8d738cbbe5e4a367472c4604d20536664c0aa75de3d0007f4db3535406a2e" => :el_capitan
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
