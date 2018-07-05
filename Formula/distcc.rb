class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3/distcc-3.3.tar.gz"
  sha256 "125897f848b2dc00cbdb62cf9e618a5e942eb7d70350a2b7b66e741cf3200045"
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "0856c0e1f163db8d9c41ca4f51938f6d32ad44638a980efa43131869e51817d4" => :high_sierra
    sha256 "482ab73be29ddb1271c4213389954ba0940e5ca63586b12fcba1e28f500c346c" => :sierra
    sha256 "24511cc04df2d860c1261b4a194cd0af0742413ff7744ec3adb2d780aed94108" => :el_capitan
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
