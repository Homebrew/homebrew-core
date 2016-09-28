class Beansdb < Formula
  desc "Yet another distributed key-value storage system"
  homepage "https://github.com/douban/beansdb"
  url "https://github.com/douban/beansdb/archive/v0.6.tar.gz"
  sha256 "b24512862f948d5191f5c43316a41f632bc386f43dcbb69b03ffffe95122a33e"

  bottle do
    cellar :any_skip_relocation
    sha256 "000333f77bcfef10426cf21619fbed7fd7591a90cd8a7e22a4f718adc2d92b51" => :sierra
    sha256 "7e11d8312ac811580ef8f1032196cac355907c2cfefa59613c9d7172451e1d21" => :el_capitan
    sha256 "3eadda79ce458bb9e5f58c15688a237c8a504538ab28209c53c30a0447791662" => :yosemite
    sha256 "a6f26d8e3aafc48c6be59c466e4a868ccaa1694b0a8b94220f145d2cf4359fee" => :mavericks
  end

  head do
    url "https://github.com/douban/beansdb.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    (var/"db/beansdb").mkpath
    (var/"log").mkpath
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <dict>
        <key>SuccessfulExit</key>
        <false/>
      </dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/beansdb</string>
        <string>-p</string>
        <string>7900</string>
        <string>-H</string>
        <string>#{var}/db/beansdb</string>
        <string>-T</string>
        <string>1</string>
        <string>-vv</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/beansdb.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/beansdb.log</string>
    </dict>
    </plist>
    EOS
  end
end
