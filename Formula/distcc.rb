class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.2/distcc-3.3.2.tar.gz"
  sha256 "64894de2970c631801d29c9962553673ea7a1d150e6855d7e166d273fca5cdfc"
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "29e22720fd883fa08b9cf4c3dfb05711b47708435cc4d64db95ba53e1e2ad06f" => :mojave
    sha256 "ba97d2888c977f6a5d51e690cebe27362ebbbef81767c4f349c41d7d9e822a19" => :high_sierra
    sha256 "90ee0314ef321c86ed4872f42043a02c385d95e0cb1f0fa4b14ac5877e12b07d" => :sierra
    sha256 "c13dc99f83f891e47906851ed16c2095bb2a3e72f0f320aae0ff53dc23fd3afa" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python"

  resource "libiberty" do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/libi/libiberty/libiberty_20180614.orig.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20180614.orig.tar.xz"
    sha256 "ffee051e01d07833ba2ae8cfaf8fffaa8047f530d725c6c6fcaf51c3d604740c"
  end

  def install
    # While libiberty recommends that packages vendor libiberty into their own source,
    # distcc wants to have a package manager-installed version.
    # Rather than make a package for a floating package like this, let's just
    # make it a resource.
    buildpath.install resource("libiberty")
    cd "libiberty" do
      system "./configure"
      system "make"
    end
    ENV.append "LDFLAGS", "-L#{buildpath}/libiberty"
    ENV.append_to_cflags "-I#{buildpath}/include"

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
