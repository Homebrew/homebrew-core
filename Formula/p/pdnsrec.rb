class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.6.tar.xz"
  sha256 "0d4c9febe6f94da0aed7e05ec7b654904fbd6229dd53bf607b63fa707b92368a"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "588ec9fbfdb74782318c4c71d1cd260678f896020f6fb83399d8788847b884a2"
    sha256 arm64_sequoia: "395ea2855b494417e3dd5dd76edf794c86df4ad2d699269a5dbbcb1c27bf7b9c"
    sha256 arm64_sonoma:  "6ba580ffe2120f914f3d2f9f706a3d879064623fcd60ec4fb4029d1ab93415e0"
    sha256 arm64_linux:   "199c023d875d0a019a913b8e3136f8cd07fe7e61e40aa04c6f3b0fff3204da95"
    sha256 x86_64_linux:  "afe73eaad022edd09f09d280b7a06c243f8d7732dd84ae6e16da7ce8900e6bfe"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "boost"
  depends_on "lua"
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl"

  def install
    args = %W[
      --sysconfdir=#{etc}/powerdns
      --disable-silent-rules
      --with-boost=#{formula_opt_prefix("boost")}
      --with-libcrypto=#{formula_opt_prefix("openssl@3")}
      --with-lua
      --without-net-snmp
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    output = shell_output("#{sbin}/pdns_recursor --version 2>&1")
    assert_match "PowerDNS Recursor #{version}", output
  end
end
