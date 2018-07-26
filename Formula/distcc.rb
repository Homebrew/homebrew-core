class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.1/distcc-3.3.1.tar.gz"
  sha256 "750665c1284a0d7ad54961751f3bbd5e09a66ea10d1f3d0660d10eb5cc27199f"
  head "https://github.com/distcc/distcc.git"

  bottle do
    rebuild 1
    sha256 "9bb480cdefe02b8bb94ed823eaa7debbfc0b860891c7c7d5333b4e7e73c823d5" => :high_sierra
    sha256 "086bc49f3e9e497e608fb9111761c7bfe22c81ed9b8adf9a12fda10b23f1136a" => :sierra
    sha256 "e3b99a82bd2ed5861c76b5715a73d50e74171189805d05c7d48bf665e3b1ad47" => :el_capitan
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
