class Nmh < Formula
  desc "The new version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.1.tar.gz"
  sha256 "f1fb94bbf7d95fcd43277c7cfda55633a047187f57afc6c1bb9321852bd07c11"
  revision 1

  bottle do
    sha256 "9c53df993c2f8f0dd45dea112d082d7cfc67efd34e58be2f62d95bfb44d3c9b7" => :mojave
    sha256 "f46c5ca5a87081a9a8f7f454e0cb36de543dff666ac0ba8e1bcb867a2f7e7763" => :high_sierra
    sha256 "8b70320e7046fc756ba490a44d5f7923a0e45db4f645dc02f80c19823eefa823" => :sierra
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
