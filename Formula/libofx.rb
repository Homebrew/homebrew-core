class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://github.com/libofx/libofx"
  url "https://github.com/libofx/libofx/releases/download/0.10.8/libofx-0.10.8.tar.gz"
  sha256 "d7133fb939ac0e46507cf7a5de7678b52bf6bcc7be87adc94b761c2cd12ce320"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "92c5602913813e5d0d8c58d0d1acaa93ec7b8def4a9ab4b335991329de126246"
    sha256 arm64_big_sur:  "125f551ec80c3b2a3bdd09dc96e3365d834d285decc34ab8c0ec2a7e14ee6a10"
    sha256 monterey:       "5b3426dc4388d8440611308107c1f080277c0ae094ee64db45bf7403130aff33"
    sha256 big_sur:        "a7695535ccbaa2aee50fc356bc4e9e75cae8b6f8a7686c97ccdca4de42befdbe"
    sha256 catalina:       "4933214b017210e8b4b9dc9fd2b067365529f80f15573f3ef6057047eb437ec1"
    sha256 x86_64_linux:   "9c7ef8f55e26e9cc571e8a5dc051bc96d56bcb1f8643f49e32f3d20b6efb8823"
  end

  head do
    url "https://github.com/libofx/libofx.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gengetopt" => :build
    depends_on "libtool" => :build
  end

  depends_on "open-sp"

  def install
    ENV.cxx11

    system "./autogen.sh" if build.head?

    opensp = Formula["open-sp"]
    system "./configure", "--disable-dependency-tracking",
                          "--with-opensp-includes=#{opensp.opt_include}/OpenSP",
                          "--with-opensp-libs=#{opensp.opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.ofx").write <<~EOS
      OFXHEADER:100
      DATA:OFXSGML
      VERSION:102
      SECURITY:NONE
      ENCODING:USASCII
      CHARSET:1252
      COMPRESSION:NONE
      OLDFILEUID:NONE
      NEWFILEUID:NONE

      <OFX>
        <SIGNONMSGSRSV1>
          <SONRS>
            <STATUS>
              <CODE>0
              <SEVERITY>INFO
            </STATUS>
            <DTSERVER>20130525225731.258
            <LANGUAGE>ENG
            <DTPROFUP>20050531060000.000
            <FI>
              <ORG>FAKE
              <FID>1101
            </FI>
            <INTU.BID>51123
            <INTU.USERID>9774652
          </SONRS>
        </SIGNONMSGSRSV1>
        <BANKMSGSRSV1>
          <STMTTRNRS>
            <TRNUID>0
            <STATUS>
              <CODE>0
              <SEVERITY>INFO
            </STATUS>
            <STMTRS>
              <CURDEF>USD
              <BANKACCTFROM>
                <BANKID>5472369148
                <ACCTID>145268707
                <ACCTTYPE>CHECKING
              </BANKACCTFROM>
              <BANKTRANLIST>
                <DTSTART>20000101070000.000
                <DTEND>20130525060000.000
                <STMTTRN>
                  <TRNTYPE>CREDIT
                  <DTPOSTED>20110331120000.000
                  <TRNAMT>0.01
                  <FITID>0000486
                  <NAME>DIVIDEND EARNED FOR PERIOD OF 03
                  <MEMO>DIVIDEND ANNUAL PERCENTAGE YIELD EARNED IS 0.05%
                </STMTTRN>
                <STMTTRN>
                  <TRNTYPE>DEBIT
                  <DTPOSTED>20110405120000.000
                  <TRNAMT>-34.51
                  <FITID>0000487
                  <NAME>AUTOMATIC WITHDRAWAL, ELECTRIC BILL
                  <MEMO>AUTOMATIC WITHDRAWAL, ELECTRIC BILL WEB(S )
                </STMTTRN>
                <STMTTRN>
                  <TRNTYPE>CHECK
                  <DTPOSTED>20110407120000.000
                  <TRNAMT>-25.00
                  <FITID>0000488
                  <CHECKNUM>319
                  <NAME>RETURNED CHECK FEE, CHECK # 319
                  <MEMO>RETURNED CHECK FEE, CHECK # 319 FOR $45.33 ON 04/07/11
                </STMTTRN>
              </BANKTRANLIST>
              <LEDGERBAL>
                <BALAMT>100.99
                <DTASOF>20130525225731.258
              </LEDGERBAL>
              <AVAILBAL>
                <BALAMT>75.99
                <DTASOF>20130525225731.258
              </AVAILBAL>
            </STMTRS>
          </STMTTRNRS>
        </BANKMSGSRSV1>
      </OFX>
    EOS

    output = shell_output("#{bin}/ofxdump #{testpath}/test.ofx")
    assert_equal output.scan(/Account ID\s?: 5472369148  145268707/).length, 5
    %w[0000486 0000487 0000488].each do |fid|
      assert_match "Financial institution's ID for this transaction: #{fid}", output
    end
  end
end
