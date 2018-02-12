class Burp < Formula
  desc "Network backup and restore"
  homepage "http://burp.grke.org/"

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.1.28/burp-2.1.28.tar.bz2"
    sha256 "c625fed9a9d911f25007cb0189d941efbf16449cf02e8599d6f506901a9ecd7d"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :revision => "1048ed82f22fe57f1e139821ae3a3ce6a52f1002"
    end
  end

  bottle do
    sha256 "9514e480afa08c9dfe14be59610beaf691a6bfe1e2d58327fe57278f822aeedc" => :high_sierra
    sha256 "c67d91fb1c454af07cf7097484f673e91125aa89ff7e6de6eca8cde508cbe00b" => :sierra
    sha256 "effe7e754cefe38fa11a50409c7c3fc0ce9c84551de03dfd64302a382622378a" => :el_capitan
    sha256 "bada46216bdbb6e1e3f6c6506a1e9c8578a077ef8e1fdbcef40c4ef513c84d38" => :yosemite
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
    system bin/"burp", "-v"
  end
end
