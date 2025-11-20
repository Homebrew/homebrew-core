class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/548/aqbanking-6.6.4.tar.gz"
  sha256 "a25c209538fa163f3749676a084493c9a43d9045a945aeee2db25dfd9a502b7f"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "95db5bea2a65e112463cf4c5a72edabad0cf956eb99f229233486ae1b338eb3f"
    sha256 arm64_sequoia: "2844c4cd3e5278d5b3aadf63f4c12a433e7f85ea63136ab3277223324e86b593"
    sha256 arm64_sonoma:  "8a28d4318219b92bd8c0a7401112abe1c76c649087ae969a234eed69ffdd93df"
    sha256 sonoma:        "1f2dafb70c12b688cdeeb4747adfdb27680ba4e2726d1e11c7d6397147093372"
    sha256 arm64_linux:   "2778ef486f30ba37ab9fa619159ba213e6af872d53742e96cec3ea31d25e5d0f"
    sha256 x86_64_linux:  "4219de3dce03e13d7af4a8eba3be2d7c08af46a8247d537bae1051118253ccfd"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkgconf" # aqbanking-config needs pkg-config for execution

  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
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
