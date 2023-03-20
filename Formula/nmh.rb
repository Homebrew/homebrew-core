class Nmh < Formula
  desc "New version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/nmh/nmh-1.8.tar.gz"
  sha256 "366ce0ce3f9447302f5567009269c8bb3882d808f33eefac85ba367e875c8615"
  license "BSD-3-Clause"

  livecheck do
    url "https://download.savannah.gnu.org/releases/nmh/"
    regex(/href=.*?nmh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b19ca14a98f0e0d57410ab8657327d8bacb06fdf298c43f629dce4e2a7dc8e48"
    sha256 arm64_monterey: "d80d7dcbe30bbbf4caab0171bfab9699e4617302b03f965ea4bfe400ec9a88e7"
    sha256 arm64_big_sur:  "f9b055924ae29046bce486620efd1fee6ce619538da3ed0c2abd7eaf159e250d"
    sha256 ventura:        "b46e2faf510ed02b0bf422ef23c05cfcf47ec1365cc3f4e54cf2ff17f7548ac7"
    sha256 monterey:       "6a5e9dd3ea5b6afac624973fcbbb71e0affceffe69fa05c96c400cc99268f11a"
    sha256 big_sur:        "6143ca12870b982d30f5603af14e9f1ab6c00ff2f29e0cb2cc93833aee319941"
    sha256 x86_64_linux:   "803dd671f3de823a42b001242a1239280b828b5714018662774e320f7bfa61cd"
  end

  head do
    url "https://git.savannah.nongnu.org/git/nmh.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl@1.1"
  depends_on "w3m"

  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "gdbm"
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}", "--libdir=#{libexec}",
                          "--with-cyrus-sasl",
                          "--with-tls"
    system "make", "install"

    # Remove shim references
    inreplace prefix/"etc/nmh/mhn.defaults", Superenv.shims_path/"curl", "curl"
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
