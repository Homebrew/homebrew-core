class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.0.0.tar.xz"
  sha256 "f1c96aff6e873a2f9b1b8c2441d5a7801dd48d3abdb738a4d24b26c2a8fbe6c4"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "c272f0587806e6360816a6f8ed14fa22f99b6706ac3742a2461ef325f7e53558" => :catalina
    sha256 "a85ecdf48f4d65a6015250fd0c1303ab9c901d7c0fbd68246f86791bfd670398" => :mojave
    sha256 "9f9d8cedd6d9afdc7ecf4e7cbdec2ef4adee5daa79248c1c5e480b01761e951a" => :high_sierra
  end

  head do
    url "https://gitlab.labs.nic.cz/knot/knot-dns.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-module-dnstap",
                          "--enable-dnstap"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
      server:
        rundir: "#{var}/knot"
        listen: [ "0.0.0.0@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    EOS
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>EnableTransactions</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/knotd</string>
        </array>
        <key>StandardInPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/knot.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end
