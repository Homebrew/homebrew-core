class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://github.com/libofx/libofx"
  url "https://github.com/libofx/libofx/releases/download/0.10.5/libofx-0.10.5.tar.gz"
  sha256 "570ea744fb654750ed9c60456c771e7cbb035465f409e9ee1118f671b47b3bc3"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "8f7250faec67d50542f6f2cb045411b184ea422d36c4c6a1376d663cca3905ac"
    sha256 arm64_big_sur:  "9fefe346a497717fd525530bf249796b796a7926ce8bd263d8c01c6e0cc08e8f"
    sha256 monterey:       "8f8f85bc670a1e5c17114f5b49ff8f5fa0ba97d95ac00249fee652d46fadb55f"
    sha256 big_sur:        "e4feea6f79cc945d1a62838655133c6fcd26e82fb9db49c2a12e94e2ec84b529"
    sha256 catalina:       "b97732a6d64cecf91e711d3ce1d6539b4678ef57c4cbd08d51551bd869593b2c"
    sha256 x86_64_linux:   "8cbdc7e82d067c3ee16993c3741cee5a84deb0621f9c5a28ab55bb260dc6c4f9"
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
