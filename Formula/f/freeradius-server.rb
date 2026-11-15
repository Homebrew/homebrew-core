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
    rebuild 1
    sha256 arm64_golden_gate: "d7149365cb570ebb614aebd846a5e9570b3579dd0372f604b45fc5d8204af5f5"
    sha256 arm64_tahoe:       "ef3f26b5994560ed1a500cdc41f1252ca80517e0f202ea0266db872a3a7fa43b"
    sha256 arm64_sequoia:     "db633983aa249511fc8cd50a6172e51c3b4f0d47176cc8bdf7aa591dbdb192d4"
    sha256 arm64_linux:       "cbf0847480affcd294b7aad591bf22e88faf7d22b95976228d43e279da5b01e3"
    sha256 x86_64_linux:      "9fb29c45da9f274e0ef0dc46f1efe4976ebab6455b1f103c2f5368527af1df60"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@4"
  depends_on "python@3.15"
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
