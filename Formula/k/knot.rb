class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.8.tar.xz"
  sha256 "6730a73dbfc12d79d8000ffe22d36d068b7467e74bee1eb122ac4935ecea49f9"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "d411d22dd0dc3088be3408bffe8695ccf2ffc65ec0f3f4bccb53f26decfd0a57"
    sha256 arm64_sequoia: "e43d4bacf0ad15d1af2e4ae476aba42afac58c882c93e379185f0c1704f4b254"
    sha256 arm64_sonoma:  "c0c48f14b870826e0a2bc0a8f8890cec65ffae4f2248b3905381732015ef7606"
    sha256 arm64_ventura: "c3d5026a5980636a322b8eb6af567223695203e352b100273ac492734e6ee4bd"
    sha256 sonoma:        "d869f8b3e6bc83d0a9e0d2184f41817fda21bf5e928a181e79f5d7461821f573"
    sha256 ventura:       "d81e4175eedb24395ff43b1818c33f40321c733af0298d58ec9fffe50a181e15"
    sha256 arm64_linux:   "52f6759f39c941baf95849c3f962a5e44a13eaa6987263e45042ee0cedd7ea2f"
    sha256 x86_64_linux:  "9222773acdc2894206692782ed44f515f9b0397cfcb9707abe8917a546a863a9"
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
  end

  def post_install
    (var/"knot").mkpath
  end

  def knot_conf
    <<~EOS
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
    EOS
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
