class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.org"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dnscrypt-proxy/dnscrypt-proxy_1.9.5.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/d/dnscrypt-proxy/dnscrypt-proxy_1.9.5.orig.tar.gz"
  sha256 "64021fabb7d5bab0baf681796d90ecd2095fb81381e6fb317a532039025a9399"
  revision 3

  head "https://github.com/jedisct1/dnscrypt-proxy.git"

  bottle do
    sha256 "14222baf3db570e64577e12af6b7d6aff571a04e77ce6a97b394ac60f409dc70" => :high_sierra
    sha256 "a40f76505186a1a32b7ef18bdb7e522ffd17e327a8c3a3434c688673993ff6ed" => :sierra
    sha256 "2ace7b2dc537c46d9a27e7cc095fb23381c8b9eae3a1093001093b57f2fd6d8d" => :el_capitan
  end

  option "without-plugins", "Disable support for plugins"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libsodium"
  depends_on "minisign" => :recommended if MacOS.version >= :el_capitan
  depends_on "ldns" => :recommended

  def install
    # Modify hard-coded path to resolver list & run as unprivileged user.
    inreplace "dnscrypt-proxy.conf" do |s|
      s.gsub! "# ResolversList /usr/local/share/dnscrypt-proxy/dnscrypt-resolvers.csv",
              "ResolversList #{opt_pkgshare}/dnscrypt-resolvers.csv"
      s.gsub! "# User _dnscrypt-proxy", "User nobody"
    end

    system "./autogen.sh"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    if build.with? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end

    system "./configure", *args
    system "make", "install"
    pkgshare.install Dir["contrib/*"] - Dir["contrib/Makefile*"]

    if build.with? "minisign"
      (bin/"dnscrypt-update-resolvers").write <<~EOS
        #!/bin/sh
        RESOLVERS_UPDATES_BASE_URL=https://raw.githubusercontent.com/dyne/dnscrypt-proxy/master
        RESOLVERS_LIST_BASE_DIR=#{pkgshare}
        RESOLVERS_LIST_PUBLIC_KEY="RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3"

        curl -L --max-redirs 5 -4 -m 30 --connect-timeout 30 -s \
          "${RESOLVERS_UPDATES_BASE_URL}/dnscrypt-resolvers.csv" > \
          "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp" && \
        curl -L --max-redirs 5 -4 -m 30 --connect-timeout 30 -s \
          "${RESOLVERS_UPDATES_BASE_URL}/dnscrypt-resolvers.csv.minisig" > \
          "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.minisig" && \
        minisign -Vm ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp \
          -x "${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.minisig" \
          -P "$RESOLVERS_LIST_PUBLIC_KEY" -q && \
        mv -f ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv.tmp \
          ${RESOLVERS_LIST_BASE_DIR}/dnscrypt-resolvers.csv
      EOS
      chmod 0775, bin/"dnscrypt-update-resolvers"
    end
  end

  def post_install
    return if build.without? "minisign"

    ENV["PATH"] = PATH.new(ENV["PATH"]).prepend(Formula["minisign"].opt_bin)
    system bin/"dnscrypt-update-resolvers"
  end

  def caveats
    s = <<~EOS
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      and under the "nobody" user using a random resolver. If you would like to
      change these settings, you will have to edit the configuration file:
      #{etc}/dnscrypt-proxy.conf (e.g., ResolverName, etc.)

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

          sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

          resolver2.dnscrypt.eu.https
    EOS

    if build.with? "minisign"
      s += <<~EOS

        If at some point the resolver file gets outdated, it can be updated to the
        latest version by running: #{opt_bin}/dnscrypt-update-resolvers
      EOS
    end

    s
  end

  plist_options :startup => true

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-/Apple/DTD PLIST 1.0/EN" "http:/www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>KeepAlive</key>
        <true/>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnscrypt-proxy</string>
          <string>#{etc}/dnscrypt-proxy.conf</string>
        </array>
        <key>UserName</key>
        <string>root</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{sbin}/dnscrypt-proxy", "--version"
  end
end
