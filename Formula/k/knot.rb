class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.5.8.tar.xz"
  sha256 "4197c902feccf32475b254c7ddaa1ac123700e3895f50b80103ffeb8352a2807"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "bbdcecfc6e0ea4541dcac260c0fdfac676d16b76baae90494fe65213b71d8a56"
    sha256 arm64_sequoia: "49f7778dd14da241092ddbf68828d6e67380c28a7dfc366d7f20eaabfc3f4901"
    sha256 arm64_sonoma:  "5b6eede65219171966859e192f4556804fa924e03cd63a3903d4ca50467fdc33"
    sha256 arm64_linux:   "b81c573044159eba52899ac644f7e95bc6de03b461dbe2f938e34ba0eee1021f"
    sha256 x86_64_linux:  "e2bac05b85f72da61b65ec57744e8b33e19306839b1d433e7c8a727a0c4f0de5"
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
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end
