class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.3/distcc-3.3.3.tar.gz"
  sha256 "bead25471d5a53ecfdf8f065a6fe48901c14d5008956c318c700e56bc87bf0bc"
  license "GPL-2.0"
  revision 2
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "3a6363381e34f80e4c589ae8029cac12f60fa317db23c1d1ef4a0419a88b562d" => :catalina
    sha256 "b1dd27aba40dd04de69f094f07d6a474045d83cc09c7972ab07c6ad77e750109" => :mojave
    sha256 "feff6f640a0b3154242e6f0a1567cd0a93b523f033fddd1ac5702bc47f0ea805" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.8"

  resource "libiberty" do
    url "https://deb.debian.org/debian/pool/main/libi/libiberty/libiberty_20200409.orig.tar.xz"
    sha256 "1807b6d4c70040d71d5c93abdbcb2c05c9ad4f64ed1802583d1107fcdfc2c722"
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
