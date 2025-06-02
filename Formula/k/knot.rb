class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://knot-dns.nic.cz/release/knot-3.4.6.tar.xz"
  sha256 "d19c5a1ff94b4f26027d635de108dbfc88f5652be86ccb3ba9a44ee9be0e5839"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://www.knot-dns.cz/download/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "62241ba2192c8ffce58930ecd47a88899eaccc4251bfb9f7ba23fe18f2e60c03"
    sha256 arm64_sonoma:  "94f5f562fe7533cb29fc2e53fb6f9308fe16b36b4f1cf41bb7caa273c16f0bfb"
    sha256 arm64_ventura: "d7b76b9ed9be9a503cc6a21c5c896f0125411dbf119e4f225894f8d2a1d03867"
    sha256 sonoma:        "9d65336182f586b314fd29bfee25c8652839c3032f9f9afa405e02ae502c8d63"
    sha256 ventura:       "f2353253ac4781bbb3436823a9e56389edf0091d03874caa3157e042fb7cba2d"
    sha256 arm64_linux:   "719cc905109bf0ca8a68b009af89ba49a9e2b6f0caa1d90c82a845abd1d1ef55"
    sha256 x86_64_linux:  "8e0bf75312b54c8edd092dd36139829eaefb5b0f0160f5053d5b47d3a65dedf2"
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

  # Fix 'knot/modules/rrl/./kru.inc.c:250:7: error: always_inline function' on macOS 13 and 14,
  # see https://github.com/Homebrew/homebrew-core/pull/219163.
  # Remove in next release.
  patch do
    url "https://gitlab.nic.cz/knot/knot-dns/-/commit/509d9d82b51c58ea572dccb09f4fdbe1a3c2571e.diff"
    sha256 "c9b0d2dd5dddbe3d2fc0b817bbc3171f34fb73d0b099bf2b52cf101f4d0239ff"
  end

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
