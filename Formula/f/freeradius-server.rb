class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 2
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  stable do
    url "https://github.com/FreeRADIUS/freeradius-server/releases/download/release_3_2_10/freeradius-server-3.2.10.tar.gz"
    sha256 "40e0cdfdcceb22cf0acb79bc29cf7c32995466a61fda09445ce5220608a55afd"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/FreeRADIUS/freeradius-server/commit/6658c9e375637ce0bd14bed733270d863224431e.patch?full_index=1"
      sha256 "98a204233c5bed7fb1f73d9b8d6d3edcd36cbaad3268ac3f5653f2bcbd84cbc7"
      type :backport
    end
  end

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_golden_gate: "a50fc97d64a71a8f518163ac072d17a31f9293673bcb652f5004972a9a0063c9"
    sha256 arm64_tahoe:       "d502d714e8521d018c3e06faf742c0d357725db18c4f574674cb0d6871320b3a"
    sha256 arm64_sequoia:     "5dcef7e0b6f785f74d13408b62130864803b22cb334eeaa3d3c7b9d3cc2e2252"
    sha256 arm64_linux:       "61e23770a0c3ecea031904854ab9b119ff59f412fb4d38885ecac03d1e396fff"
    sha256 x86_64_linux:      "9ca8034146bf722e409a8a4f1aedd8ce7abc46a09f14bce9d842ba76396e417c"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@4"
  depends_on "python@3.14"
  depends_on "talloc"

  uses_from_macos "krb5"
  uses_from_macos "libpcap"
  uses_from_macos "libxcrypt"
  uses_from_macos "perl"

  # Links to macOS sqlite and libedit prior to Tahoe
  on_system :linux, macos: :tahoe_or_newer do
    depends_on "readline"
    depends_on "sqlite"
  end

  on_linux do
    depends_on "gdbm"
  end

  def install
    ENV.deparallelize

    args = %W[
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{formula_opt_include("openssl@4")}
      --with-openssl-libraries=#{formula_opt_lib("openssl@4")}
      --with-talloc-lib-dir=#{formula_opt_lib("talloc")}
      --with-talloc-include-dir=#{formula_opt_include("talloc")}
    ]
    args << "--without-rlm_python" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"

    (var/"run/radiusd").mkpath
    (var/"log/radius").mkpath
  end

  test do
    assert_match "77C8009C912CFFCF3832C92FC614B7D1",
                 shell_output("#{bin}/smbencrypt homebrew")

    assert_match "Configuration appears to be OK",
                 shell_output("#{bin}/radiusd -CX")
  end
end
