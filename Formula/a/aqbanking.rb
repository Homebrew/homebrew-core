class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/535/aqbanking-6.6.1.tar.gz"
  sha256 "3250fa6d893f816d29c19af35fe5fccb74c080e21753fd9e52579a792dd48567"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_sequoia: "48c2a1b90df98367c37585e549b42239dea3b3d4e479609524650e408a3ab7a8"
    sha256 arm64_sonoma:  "d9253ec20ce7572ef9c9d696cba920f9025616862ab7e16865c45c66a0f92a96"
    sha256 arm64_ventura: "7e65d826f391a8700065909c258e9bffe3de9d099728e75860a9a2173b2f2fd7"
    sha256 sonoma:        "bc5ba9210848ff416ec017513c6ab39d2ec588b7c0bf13fa3ca97bb8c7af0f6f"
    sha256 ventura:       "9862c9c023c74fa551f746c4a2ed9d80f466ca63c1936cbf2d5c53d08ab1d41e"
    sha256 x86_64_linux:  "72dae8cdc9e5da902c8c9607867755a10befade0f8d2173767df48449809381a"
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
