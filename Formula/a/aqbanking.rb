class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/652/aqbanking-6.9.1.tar.gz"
  sha256 "fc94a2bebfbb4fc26b98dc93c8fa36a8026298cd7995f79821c480db35587f6b"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 arm64_tahoe:   "8c8fdb26f0aacf74243d34985de6fc00fb00a87bb3a8de0c34bc6978973dea11"
    sha256 arm64_sequoia: "a88b5a56e38208777a623d3a7865e0d89355086344b86f8210be8b9aa320e542"
    sha256 arm64_sonoma:  "f3508f1bdba0172cf7b87edbff32df1ed19fc8556388ae5beeda8fa86d00e5c0"
    sha256 sonoma:        "42a31e631f114cff35540a147126205d61fbbf12256e157915a3333223c30bdb"
    sha256 arm64_linux:   "419c0a00b43bfed60fa902cedf514598b5f70be16eb1ac2ca8b51f54222d1117"
    sha256 x86_64_linux:  "f3a492175e1ce3aa57a72b962124be3eefe6d499950e36e0a697979aacc2ba36"
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
