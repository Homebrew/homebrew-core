class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/releases/download/release_3_2_10/freeradius-server-3.2.10.tar.gz"
  sha256 "40e0cdfdcceb22cf0acb79bc29cf7c32995466a61fda09445ce5220608a55afd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  revision 1
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_tahoe:   "532b3720fb3fc420f4585af91d229398d6ac2ffa377954ee84f282870fca1fb2"
    sha256 arm64_sequoia: "cdb9e076e72940aa871e452671283bb683e987c43c71bdf51a8283c60bb6a157"
    sha256 arm64_sonoma:  "7dfe6d59e276163df2bf90211f1b89a2db3e480068f5cff66af3a65fc5010c2b"
    sha256 sonoma:        "237c68e330d5f43f2c772dcbeec6f40d6e7c4ab3f4d4baf08cbac481d3ddd7ae"
    sha256 arm64_linux:   "277c2f46a945caba616e1f4b25b9ecf00fe14d6bcb7537d4cf6f4ebf454debc0"
    sha256 x86_64_linux:  "f5b14e3602ba57cdb296bd1aee12f3440043f9ae958d8d8f7014b2d95b1b8680"
  end

  depends_on "collectd"
  depends_on "json-c"
  depends_on "openssl@3"
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
      --with-openssl-includes=#{formula_opt_include("openssl@3")}
      --with-openssl-libraries=#{formula_opt_lib("openssl@3")}
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
