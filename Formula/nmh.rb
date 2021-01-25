class Nmh < Formula
  desc "New version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.1.tar.gz"
  sha256 "f1fb94bbf7d95fcd43277c7cfda55633a047187f57afc6c1bb9321852bd07c11"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/nmh/"
    regex(/href=.*?nmh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 "7dcce1935d412880d7484d77230a8446fc917dbc6bd8288df51e92c0a1a8106c" => :big_sur
    sha256 "8424c60947db61aa2902836e12ac551c49c0783f3ab74746a57beff8f8361026" => :arm64_big_sur
    sha256 "891c5b5a3353772b1f450968c6a5aa25f22131cf567a32891694161af64e513e" => :catalina
    sha256 "404bb9d70fbae0d224bc8c4e1e29c1e3f950df5ffac8e4f9a2805bb9d4a9c9f3" => :mojave
  end

  head do
    url "https://git.savannah.nongnu.org/git/nmh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"
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
