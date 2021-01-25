class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.5/distcc-3.3.5.tar.gz"
  sha256 "6a20c0896d546c507dbf608660d22f5da606509f52d2e97f6c47ca9b8c1cc405"
  license "GPL-2.0-or-later"
  head "https://github.com/distcc/distcc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "b62f0b905384b156b5834f3df6c1d5af48e664a877073a13e0fe61c08e066a19" => :big_sur
    sha256 "4cf6517529e644492aec155d68cb5d847b79a3371beb7ca6f007c852902951a1" => :arm64_big_sur
    sha256 "385e370489a3334d46ccc67a809f1e52acd458c86793895002d4eb648147c5f2" => :catalina
    sha256 "f156ea68069cfacf4292940e8adb399b463f27753e64bf3ea175a2889e12a0b0" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20201110.orig.tar.xz"
    sha256 "91e14f26da5bd65e3e74c036e7b7775aec17204fde62aea4b12b686eff2e3911"
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

  plist_options manual: "distccd"

  def plist
    <<~EOS
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
