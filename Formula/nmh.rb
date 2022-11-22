class Nmh < Formula
  desc "New version of the MH mail handler"
  homepage "https://www.nongnu.org/nmh/"
  url "https://download.savannah.gnu.org/releases/nmh/nmh-1.7.1.tar.gz"
  sha256 "f1fb94bbf7d95fcd43277c7cfda55633a047187f57afc6c1bb9321852bd07c11"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://download.savannah.gnu.org/releases/nmh/"
    regex(/href=.*?nmh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 arm64_ventura:  "a6100dd22a0dd8c469c69485b1430fe133b0ca88bc3d422431137a079269c711"
    sha256 arm64_monterey: "726887989054eb588cf773ff213bd01429119cb0c396648b865c173171bd7a39"
    sha256 arm64_big_sur:  "c22c2cfe619a7b8529f2489492bf2294864fd36735174925da0a696bc1a11ea1"
    sha256 ventura:        "9c813b6ebcf55c92eb65cc3fdf1369c018c5ae10d6f21ab8b0595efc6215d646"
    sha256 monterey:       "b9a5abc2d6bd14beae38367a355a193fca51afa00d2142ca4ef61706bb5b8b27"
    sha256 big_sur:        "9915709d40e6f0a0fca7fda01193dd82525057db51144556b2f857f1d4ee1833"
    sha256 catalina:       "2e8c9560b9bc112f2dd145a18e3e055fb69d91005bb9e336c439055538b5cc0c"
    sha256 x86_64_linux:   "6a1e78254cb9bfb2f6508f90bb65bebc86b9c97171c81480558f197a40776bb0"
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
