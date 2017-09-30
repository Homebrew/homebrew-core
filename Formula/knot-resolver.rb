class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  revision 2
  head "https://gitlab.labs.nic.cz/knot/knot-resolver.git"

  stable do
    url "https://secure.nic.cz/files/knot-resolver/knot-resolver-1.4.0.tar.xz"
    sha256 "ac19c121fd687c7e4f5f907b46932d26f8f9d9e01626c4dadb3847e25ea31ceb"
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/62168c0/knot-resolver/fix-loading-modules-on-Darwin.diff"
      sha256 "326a720d6ca0bb7455ce1833b9e93d4054b002f32de7676773f28b4023bcf52f"
    end
  end

  bottle do
    sha256 "fb072f124aaa66c50c552df8fab88d58694c6e802cb15531eaf6606b61c92efd" => :high_sierra
    sha256 "b201a1d1e00da7dd131d3e13f45e49bcdfd3bee096b821208ca2cae16785455b" => :sierra
    sha256 "1acd3ec0d7340640a4e1429b7b1177887ac863d1f59b953f7c1ab7470a9c1a06" => :el_capitan
  end

  option "without-nettle", "Compile without DNS cookies support"
  option "with-hiredis", "Compile with Redis cache storage support"
  option "with-libmemcached", "Compile with memcached cache storage support"

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "knot"
  depends_on "luajit"
  depends_on "libuv"
  depends_on "lmdb"
  depends_on "nettle" => :recommended
  depends_on "hiredis" => :optional
  depends_on "libmemcached" => :optional

  def install
    %w[all check lib-install daemon-install modules-install].each do |target|
      system "make", target, "PREFIX=#{prefix}", "ETCDIR=#{etc}/kresd"
    end

    cp "etc/config.personal", "config"
    inreplace "config", /^\s*user\(/, "-- user("
    (etc/"kresd").install "config"

    (etc/"kresd").install "etc/root.hints"

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
