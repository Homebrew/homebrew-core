class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/654/aqbanking-6.9.2.tar.gz"
  sha256 "244b5f7a139f829928f5cdc3f5f7488517b3e8aa63625a92741c3efc1892bb3f"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "8b4561cfe47773cead99f0b96cf278f7ee042cd96bad2013688c1f250cbe09ba"
    sha256 arm64_sequoia: "67524a1018bf8992863d48c4229b6d84d7df2574ff4c87c58415bfd16e614e9c"
    sha256 arm64_sonoma:  "1a23408a0bbe6e697f61d26e306124897947f818dbe7c5654d93193335a97b37"
    sha256 sonoma:        "06d94727ba0e5731784a4e4f070c59b8c252da028932295a8847460b60a7b686"
    sha256 arm64_linux:   "ca470f16320215f548d2f0b01ccb05ca2038be755b1c097c64fdbe159e08ad48"
    sha256 x86_64_linux:  "de7bcacc092a7f9bd89539015a66233ec27073186fba5cce121d6d136efcab6e"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize

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
