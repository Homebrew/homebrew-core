class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.2.1.tar.xz"
  sha256 "51efa36f92679b25d43dbf8ba543e9f26138559f0fa1ba5fae172f5400659c8f"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8b073bf71a76cb181f9660d9d196eef8ad02457f3faa26939ef9f9899b438a91"
    sha256 arm64_big_sur:  "8ab10f4183aced3580f8f3c26411e5b4d15ec444d8c616f40911c64d9adb0d00"
    sha256 monterey:       "d0126f439612b31cdc3fabca9d46b0f395c0e724a127a0eed3a82e28cd8ce202"
    sha256 big_sur:        "ddc0ded674de8fbbe5e2112515cddb613f24300ecf68d5beeb315268c298dd6f"
    sha256 catalina:       "6e06f072d30d0498a8982f09cba93b7244a15517a193099705475fff81038da9"
    sha256 x86_64_linux:   "d47a1d2ab36321cd64d334c8608276db712061e7fedd8601854681278d60833f"
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
  service do
    run opt_sbin/"knotd"
    input_path "/dev/null"
    log_path "/dev/null"
    error_log_path var/"log/knot.log"
  end

  test do
    system bin/"kdig", "www.knot-dns.cz"
    system bin/"khost", "brew.sh"
    system sbin/"knotc", "conf-check"
  end
end
