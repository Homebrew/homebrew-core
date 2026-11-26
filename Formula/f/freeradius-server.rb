class FreeradiusServer < Formula
  desc "High-performance and highly configurable RADIUS server"
  homepage "https://freeradius.org/"
  url "https://github.com/FreeRADIUS/freeradius-server/releases/download/release_3_2_11/freeradius-server-3.2.11.tar.gz"
  sha256 "6cc6be535ca33ad13080b7d4114b75f810a946f11ae0788f54557a271066b114"
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
    manifest_sha256 "f5ded4cb2d6467545467f47aae494f8dbbe720fadc933377a2e7ec31423e4459"
    sha256 arm64_golden_gate: "c6529f174ebda0bfbe5b6c9c06a345da27e95cb965ba358c991bad6efaebc015"
    sha256 arm64_tahoe:       "c2a068e9b3375d8602b3c9f92551fe1b51be0382aeee7f1ab4ec72d428829505"
    sha256 arm64_sequoia:     "d5ccc04cd42f6ba3b34fd5c5ac35ad8f02fdd613adc96ddce5aa6096e33c41da"
    sha256 arm64_linux:       "a753a9d5af92edcdf82ecd1ae27924367b5f7e7ddd2a57196ac4d14ad354626d"
    sha256 x86_64_linux:      "9b6535df0fb1055363589575de17d3a8b99a28c69b61f281991d8ac321b4c2a9"
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

    openssl = dep("openssl")
    args = %W[
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-openssl-includes=#{openssl.opt_include}
      --with-openssl-libraries=#{openssl.opt_lib}
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
