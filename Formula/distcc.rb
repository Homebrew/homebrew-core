class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.4/distcc-3.4.tar.gz"
  sha256 "2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d"
  license "GPL-2.0-or-later"
  head "https://github.com/distcc/distcc.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_big_sur: "04069e9b45f06f5a439446418d1f34e6f96cdfa46c88011a2ea262c83a7bc902"
    sha256 big_sur:       "7ed33d20026cb81aadb27a99de88dc38fde50c0af5aa15ac28476bf8e4d9b472"
    sha256 catalina:      "82d5031a707c7805a5d5629315db68b9baacca9581361d10445266071e784d66"
    sha256 mojave:        "fd555e2ee84db99b171684e4a83a6944b95785780501ff85786013058ce4a7db"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.9"

  resource "libiberty" do
    url "https://ftp.debian.org/debian/pool/main/libi/libiberty/libiberty_20210106.orig.tar.xz"
    sha256 "9df153d69914c0f5a9145e0abbb248e72feebab6777c712a30f1c3b8c19047d4"
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
