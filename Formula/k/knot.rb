class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.6.1.tar.xz"
  sha256 "9af5818f6b53f8a387e013676a308d5c932bdb469d47f1ca926e1842badea75e"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]
  compatibility_version 1

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "f578c26b2282535823b67151af62573ed2ebab6c1984c197fd36240e535b5195"
    sha256 arm64_tahoe:       "0ea654cb14756536f630fddf6e4bea048fb19fb48183b16f8d88160eb027274d"
    sha256 arm64_sequoia:     "d5c5b8c0b1e8afcfdccedda6b7df19b53c1cd919ae0b2475474d7b11f2898742"
    sha256 arm64_linux:       "b069e93413a205e285edbf0ec8c9d78eb01f8a341e36de0e8eb7b34a93a04f18"
    sha256 x86_64_linux:      "059ad1d2c14cff208545f06dd27ded5c4dfb7c6c66c40326a04f825eecf57848"
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
