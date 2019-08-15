class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.3/distcc-3.3.3.tar.gz"
  sha256 "bead25471d5a53ecfdf8f065a6fe48901c14d5008956c318c700e56bc87bf0bc"
  head "https://github.com/distcc/distcc.git"

  bottle do
    rebuild 1
    sha256 "cc6733686bc22b48972455982fe93656bcc27f3f4fea1d202c42316a2baceb6a" => :mojave
    sha256 "e0e26dfa751cc3790a81de8ed8bda041a36ff487cbc9c18790e11a1d487893ae" => :high_sierra
    sha256 "5839cf82df4187c62f5035c26762f88ed84da15e472501ab2d9097d2c77a023e" => :sierra
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
