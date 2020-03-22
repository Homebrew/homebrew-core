class Distcc < Formula
  desc "Distributed compiler client and server"
  homepage "https://github.com/distcc/distcc/"
  url "https://github.com/distcc/distcc/releases/download/v3.3.3/distcc-3.3.3.tar.gz"
  sha256 "bead25471d5a53ecfdf8f065a6fe48901c14d5008956c318c700e56bc87bf0bc"
  revision 1
  head "https://github.com/distcc/distcc.git"

  bottle do
    sha256 "396eca7aa3ec899e2eff031b2cdcd7169939996efd98dafee94cfb9f2e658a68" => :catalina
    sha256 "4a4f365ee6991e812eb3aba1aa8bab9ae2f780e49793efe12b6b2bcb5e792fcf" => :mojave
    sha256 "f759768f1363120b7bd6b3ee7717ef75d2c703082c697f0bfc607809cf6c32f6" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "python@3.8"

  resource "libiberty" do
    url "https://deb.debian.org/debian/pool/main/libi/libiberty/libiberty_20190907.orig.tar.xz"
    sha256 "4c649c2cee918399dd5c4051bbac8d4ca4bbfb8c8e83215c00143f413578f236"
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
