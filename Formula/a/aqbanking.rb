class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/531/aqbanking-6.6.0.tar.gz"
  sha256 "37634487b95bad72b1b21397bce08cb4b15e13cb253886767c98f31712e40bfb"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "867da1207bd6888e0ccaff9e5a590a550496c75a3c108268eb735a72d88f4b63"
    sha256 arm64_sonoma:  "09eac4af03579d4a5a3a337abb3084181421c3900d4b48634ae49b40c8bf372e"
    sha256 arm64_ventura: "06bb730e2245dc7397488e452cdd1a7f1016929fd17cddbfec4bb823c1a796b4"
    sha256 sonoma:        "b6a29a9a12754837f0ded814578872416c787c6035e4903bd24f3cd74bfaa423"
    sha256 ventura:       "959125b55e5ed7918812874fd42281191a7ce553dadfe0f7d0e2db42b97eb971"
    sha256 x86_64_linux:  "f864757758e63cc53a8ad042903e7ec7a24634c3e2d635e058b20f95b43f21eb"
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
