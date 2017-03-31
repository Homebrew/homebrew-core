class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"

  stable do
    url "https://secure.nic.cz/files/knot-dns/knot-2.4.2.tar.xz"
    sha256 "37da7fcf1f194bd6376c63d8c4fa28a21899b56a3f3b63dba7095740a5752c52"

    resource "fstrm" do
      url "https://github.com/farsightsec/fstrm/archive/v0.3.1.tar.gz"
      sha256 "a61ec0bb88b1e7bab05a6c854219deb451137c4de15800fc1ee2bee4b9b0d22a"
    end
  end

  bottle do
    sha256 "9684464fc68b150cdcf389248288b840d706d3f10d8666c809e2888b93a81c3d" => :sierra
    sha256 "64b990fddfcf6d9a43450b2da146ec777b9779846e9f2bae2c4d411a5bd9d17e" => :el_capitan
    sha256 "21dc8c0c23f9d35692626bd8a145a0089de9d7906ee3f725c05270b1836f92fd" => :yosemite
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
        any: "info"

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
    system sbin/"knotc", "-c", etc/"knot.conf", "conf-check"
  end
end
