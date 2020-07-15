class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/334/aqbanking-6.2.2.tar.gz"
  sha256 "b14c2ec8069854226f8ced273c91948b8722b0e52e83c88b99df541fef2f40fd"

  bottle do
    sha256 "c5579a6f5aada2c6738e09338c5cededdeacbc0d3dd0cc3a3e0fd4c8f71d8678" => :catalina
    sha256 "3127e76e64ce70f7ceb4a42b125afe38f7176ab58a539ace3689152fa50fbf6e" => :mojave
    sha256 "f6e3e9685094ba9e507c5947825579f092a2c1b0d2f46b09d479bf59afe362a8" => :high_sierra
  end

  head do
    url "https://git.aquamaniac.de/git/aqbanking.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gettext"
  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "pkg-config" # aqbanking-config needs pkg-config for execution

  def install
    ENV.deparallelize
    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli"
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
    out = shell_output("#{bin}/aqbanking-cli -D .aqbanking listbal "\
                       "-T '$(bankcode) $(accountnumber) $(dateAsString) "\
                       "$(valueAsString) $(iban) $(bic)' < #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
