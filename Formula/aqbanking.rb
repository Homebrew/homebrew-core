class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/435/aqbanking-6.5.0.tar.gz"
  sha256 "4d2d3bea086e96ada7b6819206d4eb4168ceb7e32dce9a68dc6c6eabcc9eb63e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d9e446b646d77b35070d3949d544f2c921bd39987e90e18f619de9193c8122f5"
    sha256 arm64_big_sur:  "a726b3584d9f28941485c2ebc587c2f6c42b7f46d6107395913b8e562c249a3a"
    sha256 monterey:       "dd8f1879bb07bf8712cf2777ad63e5687cb5de4efb13af0feae02f88dfefe64e"
    sha256 big_sur:        "bd2d08d03cf5aaa9f5ebbf1c319e827030f0db7fac3f6952a9c8a0dc8ad6ac29"
    sha256 catalina:       "1cd5ee4252aaf868fb9ad14e1adb3cf229dbee853bf2e4867699cb6a035a85a3"
    sha256 x86_64_linux:   "3d7eb8830810d4841a5545a4bcba94849096a0b3d9e910e02655c1bc529cb4a4"
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
    system "autoreconf", "-fiv" if build.head?
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
