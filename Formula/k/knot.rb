class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.5.1.tar.xz"
  sha256 "a614d5226ceed4b4cdd4a3badbb0297ea0f987f65948e4eb828119a3b5ac0a4b"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "48189c230c8daec50e9f0e26149c8cd287b123addf1f92c3309d69cded55c228"
    sha256 arm64_sequoia: "6a127e356c516f8e8489b2cd237755d40e28e2390c43c0cb7a6c8760c7cb9de7"
    sha256 arm64_sonoma:  "7d487d361adb39bdd001bb53c2ce33a0110a77af11a46c9fea8fce2a7e25a347"
    sha256 sonoma:        "1a7ca4fa31801db716a56d1d8e4fff9810e2e015f29b2f9e0b32510757e746f6"
    sha256 arm64_linux:   "22ca1ccacf08df43cbd1a786d5c3d66f442992de7c7843972b5847c313cea5bc"
    sha256 x86_64_linux:  "e4a2792f9885f297ca5af9c4f8d280b7078fa1eac8998400ae4153b99ad6199f"
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
