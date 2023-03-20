class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/rdm/projects/aqbanking"
  url "https://www.aquamaniac.de/rdm/attachments/download/499/aqbanking-6.5.4.tar.gz"
  sha256 "0d16ceae76f0718e466638f4547a8b14927f1d8d98322079cd6481adde30ac99"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "86a10700be19457e9de426d1a517fff81d88f0c968edbb4422c4999b645d2db7"
    sha256 arm64_monterey: "c03595358b762a435f0e23e4302de71da6f2a4d8444ef81b83723da5626bbbd5"
    sha256 arm64_big_sur:  "5dd8f7f35e641a3b84243698b5d52e858e4c3c9bf6157386607ffc0b0d9a0ddd"
    sha256 ventura:        "135b86a8abe352be9781d0e47d34bb7daafca2dc15e2050e454a7e672cbe6308"
    sha256 monterey:       "edbeea160afd61148e15cf3d66729c6a79c5ca371fca10713112e50d7e0520ba"
    sha256 big_sur:        "970f57f5314f055f7f9b8fc72ac37bbc74d62128912da29f3428cc76c5c27082"
    sha256 x86_64_linux:   "601804c5ff8f4966834f1e1d9c8cabea7fe3a9e73081e0779b6ae26f59ad3bdd"
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
