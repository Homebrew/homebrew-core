class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.4.1.tar.xz"
  sha256 "252a2b83a9319a605103f7491d73a881e97c63339d09170ac9d525155fa41b1a"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "40082e8749481a56df7412e918e087c0f51360bbd36db7cd7ceb9d385c9f3e7d"
    sha256 arm64_sonoma:  "f2f73c64353d40f8e856e5df88d371f75464784c20ade8c2ad0a61755fb3cf08"
    sha256 arm64_ventura: "2e80e2a95b44857e41db4645818c749221b60f697e973324c28c1b4bbdf670e9"
    sha256 sonoma:        "f8cc0cce016d395cd73e4ece31482f74a476852483c99392b6c74c52fdd4542e"
    sha256 ventura:       "dc42ef9dc9ac0c7819a2f4b1cce6d13664938abb9fc955181e828a0d0837fd06"
    sha256 x86_64_linux:  "391ac0014fa29c8600caab16c37e7d63787e27a8d1580f830c1f12150b1d4fee"
  end

  head do
    url "https://gitlab.nic.cz/knot/knot-dns.git", branch: "master"

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
    # https://gitlab.nic.cz/knot/knot-dns/-/blob/master/src/knot/modules/rrl/kru-avx2.c
    ENV.runtime_cpu_detection if Hardware::CPU.intel?

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
