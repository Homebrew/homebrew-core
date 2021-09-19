class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/379/aqbanking-6.3.1.tar.gz"
  sha256 "c4989897ad14acf62e5c84161649fc1070c0f21d66c6f007f468f4b9024e0036"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "eed6d3517da17e499ff98fae30df062627cc8dc4579d834966fba7f4153b664e"
    sha256 big_sur:       "c0965a0a96ede5bdecb2745fa4755c665c83a93608a88eeac56a203ef38b835e"
    sha256 catalina:      "07cc2275239eaa92e99247361a3a3b76f3037efcdda83595c24325414d65df44"
    sha256 mojave:        "cf26dcb8732320036208b7a85a7110a549c4ac47fe94829ed9074e59fd76f4d7"
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
