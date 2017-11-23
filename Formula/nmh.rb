class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "http://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.tar.gz"
  sha256 "cd05c7ca2cae524ae99f6ba673463a5cdeff62df93e85913aa9277ae8304ce44"

  bottle do
    sha256 "5f1dcf95645d0ce83b947e79726aba3dab1443ea9177d7c8140862c91d632572" => :high_sierra
    sha256 "82df837775df9738a632f0364ff87c97790d7b4efb2f92c609f0a66b0eaada1c" => :sierra
    sha256 "0cfd2f3f5a004515700bec2ddd251ddec754f0d28e62416e7b95072543d56d04" => :el_capitan
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}", "--libdir=#{libexec}",
                          "--with-cyrus-sasl",
                          "--with-tls"
    system "make", "install"
  end

  test do
    (testpath/".mh_profile").write "Path: Mail"
    (testpath/"Mail/inbox/1").write <<~EOS
      From: Mister Test <test@example.com>
      To: Mister Nobody <nobody@example.com>
      Date: Tue, 5 May 2015 12:00:00 -0000
      Subject: Hello!

      How are you?
    EOS
    ENV["TZ"] = "GMT"
    output = shell_output("#{bin}/scan -width 80")
    assert_equal("   1  05/05 Mister Test        Hello!<<How are you? >>\n", output)
  end
end
