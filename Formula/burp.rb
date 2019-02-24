class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.2.18/burp-2.2.18.tar.bz2"
    sha256 "9c0c5298d8c2995d30d4e1a63d2882662e7056ce2b0cee1f65d7d0a6775c0f81"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :revision => "8b214aefcb81df86a7e5e0d4fa20e59a6c18bc02"
    end
  end

  bottle do
    sha256 "4cbdd3b5057ce83ac9237689bb0aae356e5d8a1a1f47032b2c282f512d7ab1a2" => :mojave
    sha256 "63448a114768888ecf29a7e43dc47bfa7d6bf8dcf29100dd686427c767d5c1f1" => :high_sierra
    sha256 "7227edca3f5ccc37bb27c129f6191440341f1d6513a720a45d0132aae52f2a69" => :sierra
    sha256 "327c71e933b05d212cc522748e4928b52da9c968f7f2ca50cee31a7ec99add0b" => :el_capitan
  end

  head do
    url "https://github.com/grke/burp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git"
    end
  end

  depends_on "pkg-config" => :build
  depends_on "librsync"
  depends_on "openssl"

  def install
    resource("uthash").stage do
      (buildpath/"uthash/include").install "src/uthash.h"
    end

    ENV.prepend "CPPFLAGS", "-I#{buildpath}/uthash/include"

    system "autoreconf", "-fiv" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/burp",
                          "--sbindir=#{bin}",
                          "--localstatedir=#{var}"

    system "make", "install-all"
  end

  def post_install
    (var/"run").mkpath
    (var/"spool/burp").mkpath
  end

  def caveats; <<~EOS
    Before installing the launchd entry you should configure your burp client in
      #{etc}/burp/burp.conf
  EOS
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>UserName</key>
      <string>root</string>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/burp</string>
        <string>-a</string>
        <string>t</string>
      </array>
      <key>StartInterval</key>
      <integer>1200</integer>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
  EOS
  end

  test do
    system bin/"burp", "-V"
  end
end
