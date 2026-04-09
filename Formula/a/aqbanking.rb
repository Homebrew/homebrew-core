class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/652/aqbanking-6.9.1.tar.gz"
  sha256 "fc94a2bebfbb4fc26b98dc93c8fa36a8026298cd7995f79821c480db35587f6b"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "7db4a15d5f2aa78404440c074eb6047cc0da90d438eefbe6ffd1d9e1154c643b"
    sha256 arm64_sequoia: "f0daed13df37ec6ca3a1fc0fd4ecb0d04bbea144a726b7b3fcf787c9b1efa02f"
    sha256 arm64_sonoma:  "3a864898c11ba68aff2df0bf62de8979c194503e441aa61fd6cac264bb7a9336"
    sha256 sonoma:        "c30dcfe21ce76e17a1946569670c811c703bccd17b1daea664dd33047b91ed85"
    sha256 arm64_linux:   "52c58af371c636ab28d10a47fb435fe8b648d4cbda9603a5ff39d0bc354d5f55"
    sha256 x86_64_linux:  "13e7b2cf905b47f59136a7e109895942314e466993f248804d71f1ef3e16cc0f"
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
