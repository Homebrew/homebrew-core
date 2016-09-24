class DnscryptProxy < Formula
  desc "Secure communications between a client and a DNS resolver"
  homepage "https://dnscrypt.org"
  url "https://github.com/jedisct1/dnscrypt-proxy/releases/download/1.7.0/dnscrypt-proxy-1.7.0.tar.bz2"
  sha256 "1daf77df9092491ea0b5176ec4b170f7b0645f97b62d1a50412a960656b482e3"

  bottle do
    sha256 "6823eef358616722da3a931ee4af2efa77d76b99345b7bb7de98f7cfd9ac076f" => :el_capitan
    sha256 "2342b453a35d9ae1d272f2542f3d654be3b82d1594f250d8b97293196186de6f" => :yosemite
    sha256 "6f0e548b4ef064981611673af052fdf11132f50b7d71be6bf48728016297a876" => :mavericks
  end

  head do
    url "https://github.com/jedisct1/dnscrypt-proxy.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-plugins", "Support plugins and install example plugins."

  deprecated_option "plugins" => "with-plugins"

  depends_on "libsodium"
  depends_on "minisign" => :recommended

  def install
    system "autoreconf", "-if" if build.head?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    if build.with? "plugins"
      args << "--enable-plugins"
      args << "--enable-relaxed-plugins-permissions"
      args << "--enable-plugins-root"
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "minisign"
      (bin/"dnscrypt-update-resolvers").write <<-EOS.undent
        #!/bin/sh
        RESOLVERS_UPDATES_BASE_URL=https://download.dnscrypt.org/dnscrypt-proxy
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

    system bin/"dnscrypt-update-resolvers"
  end

  def caveats
    s = <<-EOS.undent
      After starting dnscrypt-proxy, you will need to point your
      local DNS server to 127.0.0.1. You can do this by going to
      System Preferences > "Network" and clicking the "Advanced..."
      button for your interface. You will see a "DNS" tab where you
      can click "+" and enter 127.0.0.1 in the "DNS Servers" section.

      By default, dnscrypt-proxy runs on localhost (127.0.0.1), port 53,
      and under the "nobody" user using the dnscrypt.eu-dk DNSCrypt-enabled
      resolver. If you would like to change these settings, you will have to edit
      the plist file (e.g., --resolver-address, --provider-name, --provider-key, etc.)

      To check that dnscrypt-proxy is working correctly, open Terminal and enter the
      following command. Replace en1 with whatever network interface you're using:

          sudo tcpdump -i en1 -vvv 'port 443'

      You should see a line in the result that looks like this:

          resolver2.dnscrypt.eu.https
    EOS

    if build.with? "minisign"
      s += <<-EOS.undent

        If at some point the resolver file gets outdated, it can be updated to the
        latest version by running: #{opt_bin}/dnscrypt-update-resolvers
      EOS
    end

    s
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
          <string>--ephemeral-keys</string>
          <string>--resolvers-list=#{opt_pkgshare}/dnscrypt-resolvers.csv</string>
          <string>--resolver-name=dnscrypt.eu-dk</string>
          <string>--user=nobody</string>
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
