class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/home/"
  url "https://www.aquamaniac.de/sites/download/download.php?package=03&release=208&file=01&dummy=aqbanking-5.6.12.tar.gz"
  sha256 "0652706a487d594640a7d544271976261165bf269d90dc70447b38b363e54b22"
  head "https://git.aqbanking.de/git/aqbanking"

  bottle do
    sha256 "2575b0c1cf5a836887e2f7738d556da2babae25954ba11f2e5d78bb34439a6f1" => :sierra
    sha256 "24e93d644596aed11f15fd928d8a02539b6f46d352a284cbe605b58dfa120880" => :el_capitan
    sha256 "617da4360168c242e49ed3854750e8b9bebd6cd0c86c6ecb93c9a75aeda193ed" => :yosemite
    sha256 "3316876945003596c485aff5dbec91b6173bb79de5c85513ecfe0dfe2877ad88" => :mavericks
  end

  depends_on "gwenhywfar"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "libxml2"
  depends_on "gettext"
  depends_on "gmp"
  depends_on "pkg-config" => :build
  depends_on "ktoblzcheck" => :recommended

  def install
    ENV.j1
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
    (testpath/context).write <<-EOS.undent
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
    assert_match /^Account\s+110000000\s+000123456789\s+STRIPE TEST BANK\s+03.01.2014\s+12:00\s+1324.36\s+USD\s+$/, shell_output("#{bin}/aqbanking-cli listbal -c #{context}")
  end
end
