class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.2.4.tar.xz"
  sha256 "299e8de918f9fc7ecbe625b41cb085e47cdda542612efbd51cd5ec60deb9dd13"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0ed5b8ecc4d1cb7391e582e21159004203a78fcfca55a0a831e18de898ba7b4d"
    sha256 arm64_monterey: "28445f1d2be1f59a9bc4b8b071f1c86ccbc606ad245a056852670ca8a58ed992"
    sha256 arm64_big_sur:  "a65d3037c98cb3ed8de7fa69a998b6554acd94b9067a8d3516058fc66347bec4"
    sha256 ventura:        "0eb514a1db1362748928c06cee7a9933591b798bc587c07e5ce2582109368afd"
    sha256 monterey:       "e93d86198cb560326d87274d85fb1dc294fbcffeff8a2b74c770ec6d20f6f120"
    sha256 big_sur:        "a7d6a12f9cad98538f26774d019485c29fd7114586509f8bc205f3ef5d496316"
    sha256 x86_64_linux:   "92f05c29e74cabc87c1b993931eb29f5f76efaa0da974574c29cf4ce345c37a7"
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
  depends_on "libnghttp2"
  depends_on "lmdb"
  depends_on "protobuf-c"
  depends_on "userspace-rcu"

  uses_from_macos "libedit"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-configdir=#{etc}",
                          "--with-storage=#{var}/knot",
                          "--with-rundir=#{var}/run/knot",
                          "--prefix=#{prefix}",
                          "--with-module-dnstap",
                          "--enable-dnstap",
                          "--enable-quic"

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

  service do
    run opt_sbin/"knotd"
    require_root true
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "@94.140.14.140", "www.knot-dns.cz", "+quic"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end
