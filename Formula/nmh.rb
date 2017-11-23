class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "http://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.tar.gz"
  sha256 "cd05c7ca2cae524ae99f6ba673463a5cdeff62df93e85913aa9277ae8304ce44"

  bottle do
    sha256 "7c17be97fcf0b6b79c9142887ce966868ed07c856bdd5e0ecdd9a2767a66fc51" => :high_sierra
    sha256 "62b6f1754f82dcf84674eeddfe2bf7637262324b384e6d90a52bd2a694061da0" => :sierra
    sha256 "8c508d92233154eb888357f62d84440526fd2acea65566ef5d3325fd0b57caa8" => :el_capitan
    sha256 "bdd5c9d0e4bd341df41972b4e651761798660eadbac1332409e184e5e8e2b877" => :yosemite
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
