class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-2.5.2.tar.xz"
  sha256 "286671a4ee35a5207b2e45fd0812962b481b1b543bf3d5df3a8c319c26e2f5e9"

  bottle do
    sha256 "4f06e27a71ae3c5fe02d3096fdc5d7f70ab07323f25b82e46d0fbb0e5d9e1771" => :sierra
    sha256 "f20936f3a3626817d752b831fe18746208f7d43507f716cb00a7f0813e790323" => :el_capitan
    sha256 "4141dd77281e90b97cad16c6cbf714c8822e9b161dd050de4f0e4f74f87793fd" => :yosemite
  end

  head do
    url "https://gitlab.labs.nic.cz/labs/knot.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  # due to AT_REMOVEDIR
  depends_on :macos => :yosemite

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libidn"
  depends_on "nettle"
  depends_on "openssl"
  depends_on "userspace-rcu"
  depends_on "protobuf-c"
  depends_on "fstrm"

  def install
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
