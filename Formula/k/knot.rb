class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.5.2.tar.xz"
  sha256 "6f577c247ef870a55fe3377246bc1c2d643c673cd32de6c26231ff51d3fc7093"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "5c5bcfd9d245e00a6128b8ce0d0e0d8d817a43f4fc54d9b13b74c44b6479c331"
    sha256 arm64_sequoia: "7fe456c52622f925ba46a7ec93dd0093a59da2117a9125fb29d35fd7f0101a61"
    sha256 arm64_sonoma:  "1813915fe4bf5fa11ce2a1c7729879d31a4918b98112521e17cdace37f8fc09e"
    sha256 sonoma:        "bb832bf04f8aecf909ee60849fa4dfe6be380d96473b8fe4942399e5f729a107"
    sha256 arm64_linux:   "4f794e2182ce9c25416069ef2ef7c1ccfdd6afcb35c10e6445d4dd252fc48124"
    sha256 x86_64_linux:  "b89cb9ce916f5e3a7a2f0c9e0fe8a0258ebd8a35570173d6286f514ca3bf60de"
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
