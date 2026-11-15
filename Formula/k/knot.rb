class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.6.2.tar.xz"
  sha256 "2916ac117ac77d1f2341a6562e47d797493521b791b414960a382cb5bc113e21"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]
  compatibility_version 1

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_golden_gate: "ee4be5ffb47a5903bee1cb6456c8a59785986057487d992f10c5c5c3038e1250"
    sha256 arm64_tahoe:       "f668250d0b8f7ae8be2f56b0f205f7b9463789a24ce018faba554409be3466b7"
    sha256 arm64_sequoia:     "1494d3d91b6ca219b9f48c0b49df6d3f4aa49d548e575f7274c7318970709d99"
    sha256 arm64_linux:       "094437c1c148a5184a57130d91d5be035a9de4c9ef661d43b0003b14e1646355"
    sha256 x86_64_linux:      "29d083f5d6c5acf29f10455dd7db660d56d6ba36915ef560d97339a64b29d824"
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
