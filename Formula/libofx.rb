class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://github.com/libofx/libofx"
  url "https://github.com/libofx/libofx/releases/download/0.10.7/libofx-0.10.7.tar.gz"
  sha256 "5809202588b028742d2b9d2cbe418781e326b353028738bfd8b423b9174f99ab"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "9e52fd668e692f42890245b779db4f3a0c20aa0f6db3b7e91564403d48dbb3b4"
    sha256 arm64_big_sur:  "41bcb495cfa95ecf60a0b95e399e6909eb0f269ffc47296fb7829f556b2c527d"
    sha256 monterey:       "e402ebeec4d7163e2d2df048bd7606c55496deabf6b38e654cab1216371f1dca"
    sha256 big_sur:        "cf015dd1e3c074be5f9e33c74f821c12f6f81caa4e318b4d8eb0a746b768d95d"
    sha256 catalina:       "8290d086df46116172032bfd5baae4c687a290d43be7af293178ffac7b3d5d62"
    sha256 x86_64_linux:   "45974346ba1d9b017e20bdf0944de0813bc7498cca1fc692470d519c3c456995"
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
