class Burp < Formula
  desc "Network backup and restore"
  homepage "https://burp.grke.org/"
  revision 1

  stable do
    url "https://downloads.sourceforge.net/project/burp/burp-2.2.18/burp-2.2.18.tar.bz2"
    sha256 "9c0c5298d8c2995d30d4e1a63d2882662e7056ce2b0cee1f65d7d0a6775c0f81"

    resource "uthash" do
      url "https://github.com/troydhanson/uthash.git",
          :revision => "8b214aefcb81df86a7e5e0d4fa20e59a6c18bc02"
    end
  end

  bottle do
    sha256 "a028ea604ba4bbb5abe2d9985e94ece9f673cf33e35191063eb91e356923e982" => :catalina
    sha256 "f45062f56a6cc3bc9ba09b84d9f44e599015387d6d31b0ae8a289fa74a904021" => :mojave
    sha256 "1855c5623a4d7ec1ed397f2646772d807a127f80f196c41dcae0efe7615afd8d" => :high_sierra
    sha256 "157aa6cc33291ec50b8597b3bd97b08e0a92f79e634ec122eb0911e86bc395c9" => :sierra
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
  depends_on "openssl@1.1"
  uses_from_macos "zlib"

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
