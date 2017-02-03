class KnotResolver < Formula
  desc "Minimalistic, caching, DNSSEC-validating DNS resolver"
  homepage "https://www.knot-resolver.cz"
  url "https://secure.nic.cz/files/knot-resolver/knot-resolver-1.2.1.tar.xz"
  sha256 "1b6f55ea1dfec90f45c437f23e1ab440e478570498161d0f8a8f94a439305f8c"
  revision 1

  head do
    url "https://gitlab.labs.nic.cz/knot/resolver.git"
  end

  depends_on "knot"
  depends_on "luajit"
  depends_on "libuv"
  depends_on "gnutls"
  depends_on "lmdb"

  depends_on "cmocka" => :build
  depends_on "pkg-config" => :run

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

    (buildpath/"config").write(config)
    (etc/"kresd").install "config"

    (buildpath/"root.keys").write(root_keys)
    (var/"kresd").install "root.keys"
  end

  def config; <<-EOS.undent
    -- vim:syntax=lua:
    -- Refer to manual: http://knot-resolver.readthedocs.org/en/latest/daemon.html#configuration

    net.listen(net.lo0)

    -- Unmanaged DNSSEC root TA
    trust_anchors.file = 'root.keys'

    -- Load useful modules
    modules = {
        'stats',    -- Track internal statistics
        'policy',   -- Block queries to local zones/bad sites
        'predict',  -- Prefetch expiring/frequent records
    }

    -- Cache size
    cache.size = 100 * MB
    EOS
  end

  # DNSSEC root anchor published by IANA
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
