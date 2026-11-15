class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/654/aqbanking-6.9.2.tar.gz"
  sha256 "244b5f7a139f829928f5cdc3f5f7488517b3e8aa63625a92741c3efc1892bb3f"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_golden_gate: "629e8f3ee5692f3f5538cfb704ff8f23ee3a4cb38bee5fc8ec2fc8c5c8d77782"
    sha256 arm64_tahoe:       "0df5c83604300fc1b70b8549c0559841496a02e0f1ba5a6f103c59f17aaaf6b4"
    sha256 arm64_sequoia:     "4fc0da60ea3cf71d31af15da9fa781f36f5a9278fa43a125127b4705f33b972e"
    sha256 arm64_linux:       "93f030d976154906be9e6751ee680b37a4f29c07dd152eee759f5de18ee35103"
    sha256 x86_64_linux:      "7fcefd526dc83eac4bdf3733e311bdbe094e5a1cb12f7d41f30e6356de68c907"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    ENV.deparallelize
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac? # avoid openssl linkage

    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "./configure", "--enable-cli", *std_configure_args
    # This is banking software, so let's run the test suite.
    system "make", "check"
    system "make", "install"
  end

  test do
    ENV["TZ"] = "UTC"
    context = "balance.ctx"
    (testpath/context).write <<~EOS
      accountInfoList {
        accountInfo {
          char bankCode="110000000"
          char accountNumber="000123456789"
          char iban="US44110000000000123456789"
          char bic="BYLADEM1001"
          char currency="USD"

          balanceList {
            balance {
              char date="20221212"
              char value="-11096%2F100%3AUSD"
              char type="booked"
            } #balance
          } #balanceList
        } #accountInfo
      } #accountInfoList
    EOS

    match = "110000000 000123456789 12.12.2022 -110.96 US44110000000000123456789 BYLADEM1001"
    out = shell_output("#{bin}/aqbanking-cli -D .aqbanking listbal " \
                       "-T '$(bankcode) $(accountnumber) $(dateAsString) " \
                       "$(valueAsString) $(iban) $(bic)' < #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
