class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.1.tar.gz"
  sha256 "f1fb94bbf7d95fcd43277c7cfda55633a047187f57afc6c1bb9321852bd07c11"

  bottle do
    sha256 "bbc73237ab88dcd93b91beb374b60cd2173dbd46762ad510b785228b7d4b8323" => :mojave
    sha256 "5f1dcf95645d0ce83b947e79726aba3dab1443ea9177d7c8140862c91d632572" => :high_sierra
    sha256 "82df837775df9738a632f0364ff87c97790d7b4efb2f92c609f0a66b0eaada1c" => :sierra
    sha256 "0cfd2f3f5a004515700bec2ddd251ddec754f0d28e62416e7b95072543d56d04" => :el_capitan
  end

  head do
    url "https://git.savannah.nongnu.org/git/nmh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "w3m"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
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
