class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-1.2.4.tar.xz"
  sha256 "630b2ad0bfdcf59164957a377adef8b1fddc37a58a7e1d10e76a1b497a30f036"
  head "https://gitlab.labs.nic.cz/knot/resolver.git"

  bottle do
    sha256 "e3a9bd1d72da125bb3d57d5f140da3daa295b7cdac7b621f44410d085c91f955" => :sierra
    sha256 "d256040eedca70e9883db41bcbffe8a556adcacac8468af8d29bd2f57220d15f" => :el_capitan
    sha256 "b45edc8425f4b86e1420c84ecc902f7c9497227a72868ba628b9a70177f77134" => :yosemite
  end

  depends_on "knot"
  depends_on "luajit"
  depends_on "libuv"
  depends_on "gnutls"
  depends_on "lmdb"

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build

  option "without-nettle", "Compile without DNS cookies support"
  option "with-hiredis", "Compile with Redis cache storage support"
  option "with-libmemcached", "Compile with memcached cache storage support"
  depends_on "nettle" => :recommended
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional

  def install
    %w[all check lib-install daemon-install modules-install].each do |target|
      system "make", target, "PREFIX=#{prefix}"
    end

    cp "etc/config.personal", "config"
    inreplace "config", /^\s*user\(/, "-- user("
    (etc/"kresd").install "config"

    (buildpath/"root.keys").write(root_keys)
    (var/"kresd").install "root.keys"
  end

  # DNSSEC root anchor published by IANA (https://www.iana.org/dnssec/files)
  def root_keys; <<-EOS.undent
    . IN DS 19036 8 2 49aac11d7b6f6446702e54a1607371607a1a41855200fd2ce1cdde32f24e8fb5
    . IN DS 20326 8 2 e06d44b80b8f1d39a95c0b0d7c65d08458e880409bbc683457104237c7f8ec8d
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}/kresd</string>
      <key>RunAtLoad</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/kresd</string>
        <string>-c</string>
        <string>#{etc}/kresd/config</string>
      </array>
      <key>StandardInPath</key>
      <string>/dev/null</string>
      <key>StandardOutPath</key>
      <string>/dev/null</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/kresd.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system sbin/"kresd", "--version"
  end
end
