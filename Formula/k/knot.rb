class Knot < Formula
  desc "High-performance authoritative-only DNS server"
  homepage "https://www.knot-dns.cz/"
  url "https://secure.nic.cz/files/knot-dns/knot-3.3.1.tar.xz"
  sha256 "f3f4b1d49ec9b81113b14a38354b823bd4a470356ed7e8e555595b6fd1ac80c9"
  license all_of: ["GPL-3.0-or-later", "0BSD", "BSD-3-Clause", "LGPL-2.0-or-later", "MIT"]

  livecheck do
    url "https://secure.nic.cz/files/knot-dns/"
    regex(/href=.*?knot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9bafa4e70a2de2753091a74cebba75b1ca40789176875cb52150f9685c27700c"
    sha256 arm64_ventura:  "fdab087109be263ecb271d33ab96c24a7e69e323861e6adc67f087a7d1b75f5e"
    sha256 arm64_monterey: "658ae67c5b0a97c88a0a11724876a14699888ba958ee6c64c2d775adcbeb88a0"
    sha256 arm64_big_sur:  "4fc2c4f4e3883a651f3af679e6a752ecc4005f157c7b851db00c90003bbbaa33"
    sha256 sonoma:         "27cae6a0d5a25563f1cdc8f8b5db488854cd231a691c4d49fb4978145c1ee3ba"
    sha256 ventura:        "a9053be1aaa13108e7b0af12de072db03376ace07d5e9f51883c61a35c311b39"
    sha256 monterey:       "4ea0e015df97eac68fd4512d5ec264754d185968de74c732522a6ce09fe9807c"
    sha256 big_sur:        "28a94bcdcb8cce27e8c3e7d9ff1365ffb824dd8f76389fa107cbbed549301fa6"
    sha256 x86_64_linux:   "66cca250d77ecbd4b94f8afe9e061d131cdc8c70c8c2b5438ee22dfecfca847b"
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
