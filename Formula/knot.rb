class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"

  stable do
    url "https://secure.nic.cz/files/knot-dns/knot-2.2.1.tar.xz"
    sha256 "4b587bd8299445a29990ba89087b156ab9b6bf85cbd68846766c078e5b3481d3"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm/releases/download/v0.2.0/fstrm-0.2.0.tar.gz"
      sha256 "ad5d39957a4b334a6c7fcc94f308dc7ac75e1997cc642e9bb91a18fc0f42a98a"
    end

    # error: unknown type name 'clockid_t'
    # fixed upstream; see https://github.com/farsightsec/fstrm/pull/21
    resource "fstrm_clock_patch" do
      url "https://github.com/farsightsec/fstrm/commit/c5f09123.patch"
      sha256 "24d3ee17f3b7961eb1abd26fda386227779ab94225dd2f39ce3a4b24e980bc65"
    end
  end

  bottle do
    cellar :any
    sha256 "89f74b85b5a6f42a5051d279d087bf446b42c99ddd89bfd14154d431b3cc94bb" => :el_capitan
    sha256 "f8377f2c37094fc446f167f954bfc0c3202e4d845317b0e7a140f455b9959f7a" => :yosemite
    sha256 "8295bd95060e9f067613d3c9742d231b841694afdff96eae13f448e00f1a3d13" => :mavericks
  end

  head do
    url "https://gitlab.labs.nic.cz/labs/knot.git"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm.git"
    end
  end

  # due to AT_REMOVEDIR
  depends_on :macos => :yosemite

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"
  depends_on "protobuf-c"
  depends_on "libevent"

  def install
    resource("fstrm").stage do
      if build.stable?
        Pathname.pwd.install resource("fstrm_clock_patch")
        system "/usr/bin/patch", "-p1", "-i", "c5f09123.patch"
      end

      system "autoreconf", "-fvi"
      system "./configure", "--prefix=#{libexec}/fstrm"
      system "make", "install"
    end

    ENV.append "CFLAGS", "-I#{libexec}/fstrm/include"
    ENV.append "LDFLAGS", "-L#{libexec}/fstrm/lib"
    ENV.append_path "PKG_CONFIG_PATH", "#{libexec}/fstrm/lib/pkgconfig"

    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-bash-completions=#{bash_completion}",
                          "--enable-dnstap"

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "check"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"

    (var/"knot").mkpath
  end

  def knot_conf; <<-EOS.undent
    server:
      rundir: "#{var}/knot"
      listen: [ "0.0.0.0@53", "::@53" ]

    log:
      - target: "stderr"
        any: "error"

      - target: "syslog"
        server: "info"
        zone: "warning"
        any: "error"

    control:
      listen: "knot.sock"

    template:
      - id: "default"
        storage: "#{var}/knot"
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
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
        <string>-c</string>
        <string>#{etc}/knot.conf</string>
      </array>
      <key>ServiceIPC</key>
      <false/>
    </dict>
    </plist>
    EOS
  end

  test do
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "-c", etc/"knot.conf", "conf-check"
  end
end
