class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/328/aqbanking-6.2.1.tar.gz"
  sha256 "bab601bf7c3402912438aa2919cd84d498a65749238214fcf881d2a2cfea1fd4"

  bottle do
    sha256 "95a5722e1489e556d98a230d56ddf577f31916e9d7d92624122d3b9e47d9db17" => :catalina
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

  depends_on "gettext"
  depends_on "gmp"
  depends_on "gwenhywfar"
  depends_on "ktoblzcheck"
  depends_on "libxml2"
  depends_on "libxmlsec1"
  depends_on "libxslt"
  depends_on "pkg-config"

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
