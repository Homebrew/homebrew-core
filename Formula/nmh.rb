class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "http://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.tar.gz"
  sha256 "cd05c7ca2cae524ae99f6ba673463a5cdeff62df93e85913aa9277ae8304ce44"

  bottle :disable, "Needs to look for helper programs at compile time"
  depends_on "openssl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}", "--libdir=#{libexec}",
                          "--with-cyrus-sasl",
                          "--with-tls"
    ENV.append_path "PATH", "#{HOMEBREW_PREFIX}/bin"
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
