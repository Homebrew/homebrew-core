class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/archive/refs/tags/release_3_2_10.tar.gz"
  sha256 "3e9f24439ce976c04e4c56441722a3bd18677a61dd17f67bc8863eb4ed36cd4b"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/FreeRADIUS/freeradius-server.git", branch: "master"

  livecheck do
    url :stable
    regex(/^release[._-](\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_tahoe:   "dfc3ace4d474b7b7e9e9dea74986ab82403720b532ba3d1b462a79b4b5ed3b5c"
    sha256 arm64_sequoia: "f83189a7c21c8d9e445ca71cd0622e4e18f59cb05aad8005c7bdd6d29243c583"
    sha256 arm64_sonoma:  "7e7497a7089fb2aef6e8ecef8073225989568edda94d2d5c693030d18347591f"
    sha256 sonoma:        "5465c168e3a941f1264e8951f365dddedb890e7d7f0235320f62efe738ce02d1"
    sha256 arm64_linux:   "31927c5b14d5546ad24f26139cd3d49768699e7266d350e36dc00fc237d417bb"
    sha256 x86_64_linux:  "4e608e205987fc041bcfe76c32dedcb21b217a0be7df3208e61124a2a66efd39"
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
      --with-openssl-includes=#{Formula["openssl@3"].opt_include}
      --with-openssl-libraries=#{Formula["openssl@3"].opt_lib}
      --with-talloc-lib-dir=#{Formula["talloc"].opt_lib}
      --with-talloc-include-dir=#{Formula["talloc"].opt_include}
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
