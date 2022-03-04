class Aqbanking < Formula
  desc "Generic online banking interface"
  homepage "https://www.aquamaniac.de/sites/aqbanking/"
  url "https://www.aquamaniac.de/rdm/attachments/download/400/aqbanking-6.4.1.tar.gz"
  sha256 "79adeaf05e99b5aa0d31c3eac3db37a56bb375f537b3f106a9acfcf844dadd77"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.aquamaniac.de/rdm/projects/aqbanking/files"
    regex(/href=.*?aqbanking[._-](\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "5a86ff8e93a1e454ae3588bb749378fb863230e353be6b862a36a6cf5bfed7df"
    sha256 arm64_big_sur:  "d83a2a3067d0151089605f34c2b96b72cc55b4f5258bc84575094f04c22ddb8f"
    sha256 monterey:       "f4820594692e060267a740df585c979feda7ac75adb6eae42269ecd77cfcf98b"
    sha256 big_sur:        "e15bcadc4d81ae9214ccd2b71cd9596f1431cc0d80032f4ba443cc46c7481283"
    sha256 catalina:       "329934083304ca7ca6a3a30832ca652973fa0eaacf3a493520cc850675a22b68"
    sha256 x86_64_linux:   "84a998567c4b0898daeabaf3c6bf6bf6027f625c3fbe060911dc8e9bebc35c74"
  end

  head do
    url "https://git.aquamaniac.de/git/aqbanking.git", branch: "master"

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
  depends_on "libxslt" # Our libxslt links with libgcrypt
  depends_on "pkg-config" # aqbanking-config needs pkg-config for execution

  def install
    ENV.deparallelize
    inreplace "aqbanking-config.in.in", "@PKG_CONFIG@", "pkg-config"
    system "autoreconf", "-fiv" if build.head?
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
    out = shell_output("#{bin}/aqbanking-cli -D .aqbanking listbal "\
                       "-T '$(bankcode) $(accountnumber) $(dateAsString) "\
                       "$(valueAsString) $(iban) $(bic)' < #{context}")
    assert_match match, out.gsub(/\s+/, " ")
  end
end
