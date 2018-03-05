class Burp < Formula
  desc "Network backup and restore"
  homepage "http://burp.grke.org/"

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.1.30/burp-2.1.30.tar.bz2"
    sha256 "990fb1b61bddf5cd5cc2e1bfabb80f3acc496aa6f3dadbda757a3aacace068ab"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :revision => "1048ed82f22fe57f1e139821ae3a3ce6a52f1002"
    end
  end

  bottle do
    sha256 "3f9a25cb501a8bb41aba37cf848c45d6dd0e5e58b9b99fb3ab647b3694e9d585" => :high_sierra
    sha256 "afa781546ca98f48e3f1a8f202ba4630fa0fc0037882cd81961dc8025792b05e" => :sierra
    sha256 "cce7317e40d0b4ba7cddd49523e71315f8a604d671fb29ef98fcdf1ffc3e57db" => :el_capitan
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
    system bin/"burp", "-v"
  end
end
