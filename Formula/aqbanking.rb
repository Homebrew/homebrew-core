class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/467/aqbanking-6.5.3.tar.gz"
  sha256 "6c62bf26aa42e69b21e188b54f6a5d825d6da34de1a14cbc3b67d85a9705136e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e3a12de7657644364037be15c92717200409f4d94953452adf0a77e5c357c7e1"
    sha256 arm64_big_sur:  "2e43a777b8c571a5bac1d1a0f5672c73209e73d6ec3ab2aab35ddd323beb3b26"
    sha256 monterey:       "ddfbf5a556dc6cf7ef4e5695b37909e53d16dc33ac3479f78aa4a5de1b513f8e"
    sha256 big_sur:        "8006ec44c588bb2d7e9aedf2c3ce0ff60c83359d7a897a6671007c1634431f66"
    sha256 catalina:       "69ef4f19ee0347174f58a31ba063a426c66b4413ba8f3fbb0f458c02b53451f2"
    sha256 x86_64_linux:   "6decd8373f661ce97d20985460570f52600a4f2c9633435885c79414eaa320ba"
  end

  depends_on "gettext"
  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "pkg-config" # aqbanking-config needs pkg-config for execution

  def install
    ENV.deparallelize
    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli"
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
