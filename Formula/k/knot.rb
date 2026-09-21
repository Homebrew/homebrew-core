class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.6.0.tar.xz"
  sha256 "922894f04a2835131a24c3b3edcbf761273c1b37d3dc4e46d6923ee3856af130"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]
  compatibility_version 1

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "2c767a1538418d3c7a00414faad8a4f2955d8202e9a0bc1108b8009ba5408b4e"
    sha256 arm64_tahoe:       "934edd9ccd1c78167d77ea7e7a77cf8d9d37184c4bb20a121c2f1622e90da4f2"
    sha256 arm64_sequoia:     "4a7c5d66d0f09dcbb2fb4d6f70d8a08e64a850e9beacd4dc3d5a53a611ce289e"
    sha256 arm64_sonoma:      "ac99730976e7300587bf58f815b49e7266d3abd9d1c208a017083c9af5e88976"
    sha256 arm64_linux:       "7cbeab3acff3c761059ee2cd12339c1ef779b8bff4c2fdef1543b82f9f50165a"
    sha256 x86_64_linux:      "3278bfe8e4ec923f261ea819448ffba25085c08e3fe2f0e1e2e2c04fb44de613"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "sphinx-doc" => :build
  depends_on "fstrm"
  depends_on "gnutls"
  depends_on "libidn2"
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  deny_network_access! :test

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic",
                          *std_configure_args

    inreplace "samples/Makefile", "install-data-local:", "disable-install-data-local:"

    system "make"
    system "make", "install"
    system "make", "install-singlehtml"

    (buildpath/"knot.conf").write(knot_conf)
    etc.install "knot.conf"
    (var/"knot").mkpath
  end

  def knot_conf
    <<~YAML
      server:
        rundir: "#{var}/knot"
        listen: [ "127.0.0.1@53", "::@53" ]

      log:
        - target: "stderr"
          any: "info"

      control:
        listen: "knot.sock"

      template:
        - id: "default"
          storage: "#{var}/knot"
    YAML
  end

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path File::NULL
    log_path File::NULL
    error_log_path var/"log/knot.log"
  end

  test do
    (testpath/"example.zone").write <<~EOS
      example.test. 3600 IN SOA ns.example.test. hostmaster.example.test. 1 3600 600 86400 3600
      example.test. 3600 IN NS ns.example.test.
      ns.example.test. 3600 IN A 127.0.0.1
    EOS
    system bin/"kzonecheck", "-o", "example.test.", testpath/"example.zone"
    system sbin/"knotc", "conf-check"
  end
end
