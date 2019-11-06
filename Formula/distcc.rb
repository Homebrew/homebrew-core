class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.3/distcc-3.3.3.tar.gz"
  sha256 "bead25471d5a53ecfdf8f065a6fe48901c14d5008956c318c700e56bc87bf0bc"
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "1f92fe59d82abc151c1d7769b6e8a00c5b1c591b47111d7673dbee55d8c855e8" => :catalina
    sha256 "5db52d207f099b1ffc3a9bdf59ad17b2c16f0edabe1aa984344f955c5723d449" => :mojave
    sha256 "48190c1dece9ef45931f0b178cd04843569707623d145474e8d0e2ad7cf80609" => :high_sierra
    sha256 "6dc68f19b66bed0e613611828d276ac02251d3fe5b940720376d02187a1fa1c9" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python"

  resource "libiberty" do
    url "https://deb.debian.org/debian/pool/main/libi/libiberty/libiberty_20190122.orig.tar.xz"
    sha256 "45bd422ace29f124c068ad44edf41f845b2061ee043275ef3e233a3f647ab509"
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
