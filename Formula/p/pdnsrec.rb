class Pdnsrec < Formula
  desc "Non-authoritative/recursing DNS server"
  homepage "https://www.powerdns.com/powerdns-recursor"
  url "https://downloads.powerdns.com/releases/pdns-recursor-5.4.4.tar.xz"
  sha256 "4eeb7cea4c71bd3b800505a2b4fc8549dd6f4675b7e9e1640bff1b343a49c33a"
  license "GPL-2.0-only" # with OpenSSL Exception (non-SPDX)

  livecheck do
    url "https://downloads.powerdns.com/releases/"
    regex(/href=.*?pdns-recursor[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "54a584904631f87f8ee9c41cab3e1ef94c23a22626970f1b73fe95124ea2a72c"
    sha256 arm64_sequoia: "8164c7d93b32f28542925b302141b3a61d26986aac4fc3e02bf64656e07bcb2e"
    sha256 arm64_sonoma:  "ba3d5a48d553c1980627e281d01b2c51a272e4af3dc900e6af71f28f4bae3dcd"
    sha256 sonoma:        "d7bc1f58c917867b467104f028130e12cc8a7c13922e35cafabbb1d59606ef38"
    sha256 arm64_linux:   "b39a64fc8ebba1334db1020f3e7f6e79725d2f55a47e02d500d19a81dc0cefa5"
    sha256 x86_64_linux:  "69a7535be8b2b38d80ed745a9bb1f41f940fbb7d466255a60e8ffd3cf205598f"
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
