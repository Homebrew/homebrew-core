class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/499/aqbanking-6.5.4.tar.gz"
  sha256 "0d16ceae76f0718e466638f4547a8b14927f1d8d98322079cd6481adde30ac99"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "478d929f72e9654f1bf72dbef75ca57760a6b41fb06f906ec80124b03e4d3579"
    sha256 arm64_sonoma:   "40c5e3e65530d65705cf5652d443e980595c39c7f2767e4b3719c8339ca26c6e"
    sha256 arm64_ventura:  "b9a8f344467a7d69267d994da860fade6dda407510eed4398db47f2fd3206408"
    sha256 arm64_monterey: "fcbf229d4ea7dcde5d788e088e4ff30d6f2a1a62ab2498f2e0c2913b0cda32b5"
    sha256 arm64_big_sur:  "60da3b01e9cfeef3b9d47673d8353afec5bdfa87fec21c3df9635c41492861fd"
    sha256 sonoma:         "27737d104556c605d174dcb3400f04ebeb8093481090e1d14ce457a2f600cbab"
    sha256 ventura:        "c912b990acd3cc02ead0f7619bce81e9feb78f41caa1654b4778569b3050ba2e"
    sha256 monterey:       "b989a7cb5bf36df5b829828f8452a3661d5d370d02bdce63b266fbf10ef38601"
    sha256 big_sur:        "9ab40d81b08b2d798d3dc69a6c7557bb72e07a0891338c92bb972457c0998549"
    sha256 x86_64_linux:   "f7586074ec396a050c9f210d05ae733b9697c0f9f2d366940b6937927f2cd215"
  end

  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "openssl@3"
  depends_on "pkg-config" # aqbanking-config needs pkg-config for execution

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
