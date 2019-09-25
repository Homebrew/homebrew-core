class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/107/aqbanking-5.8.2.tar.gz"
  sha256 "93ca523fe175e72042db75f8c3fc6255ab058cf82caf52796e15f030809fb15e"

  bottle do
    sha256 "7c2baa7fb1391d73701d3853ff42c2e54c34d08e0924cf8cfac188c65a7098ae" => :mojave
    sha256 "3486dd0c279143a270b1dcc7522a515a5f911a738d639f71591f800b2afdbfc2" => :high_sierra
    sha256 "75e86959e6461de20b46cd9706570aee118cc243bbe6b5cb36ff3fb046bf8697" => :sierra
  end

  head do
    url "https://git.aquamaniac.de/git/aqbanking.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt"

  def install
    ENV.deparallelize
    system "autoreconf", "-fiv" if build.head?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cli",
                          "--with-gwen-dir=#{HOMEBREW_PREFIX}"
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
          char bankName="STRIPE TEST BANK"
          char accountNumber="000123456789"
          char accountName="demand deposit"
          char iban="US44110000000000123456789"
          char bic="BYLADEM1001"
          char owner="JOHN DOE"
          char currency="USD"
          int  accountType="0"
          int  accountId="2"

          statusList {
            status {
              int  time="1388664000"

              notedBalance {
                value {
                  char value="123456%2F100"
                  char currency="USD"
                } #value

                int  time="1388664000"
              } #notedBalance
            } #status

            status {
              int  time="1388750400"

              notedBalance {
                value {
                  char value="132436%2F100"
                  char currency="USD"
                } #value

                int  time="1388750400"
              } #notedBalance
            } #status
          } #statusList

        } # accountInfo
      } # accountInfoList
    EOS

    match = "Account 110000000 000123456789 STRIPE TEST BANK 03.01.2014 12:00 1324.36 USD"
    out = shell_output("#{bin}/aqbanking-cli listbal -c #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
