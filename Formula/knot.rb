class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"

  stable do
    url "https://secure.nic.cz/files/knot-dns/knot-2.3.0.tar.xz"
    sha256 "8abf9a6562ecf2f7f4222d16ca6c75463399870db360eda7caa40530b469533c"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm/archive/v0.3.0.tar.gz"
      sha256 "531ef29ed2a15dfe4993448eb4e8463c5ed8eebf1472a5608c6ac0a6f62b3a12"
    end
  end

  bottle do
    cellar :any
    sha256 "77cc161f3dae9ecc6fe26c630cc55140b3bd5a6662f91024c9df0d849029a121" => :sierra
    sha256 "2be2cec90a8d07c9e1d598ebc6008e47a6ba202948199c14c88df85fdd0cc3cf" => :el_capitan
    sha256 "b5095005256769812335ec46099ddebc74fd5167d459327a62181077f8bd4363" => :yosemite
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
  end

  def post_install
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
