class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/354/aqbanking-6.2.6.tar.gz"
  sha256 "47e2b2610792470300f31e6a8bf9d5b7568d1cf438679911c983939564129dd5"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 big_sur:  "8b13d743e9da91d920529f19863e4f5802fd644bc80e7a9c273845ccc401b250"
    sha256 catalina: "927f33fe980274424c76779969741859f04d0fc57462a801abe21c2a6c4b5af8"
    sha256 mojave:   "8799ba10d558a50e2a377680855eedb79e34bbe6612d4cedee9f6a1cf6807aaa"
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
