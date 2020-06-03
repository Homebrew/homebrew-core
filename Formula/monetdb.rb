class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Jun2020/MonetDB-11.37.7.tar.xz"
  sha256 "8496c9cb3a5e8d5493060f173ad92f773e804d6ba03b0e0f6fa607b57642b447"

  bottle do
    sha256 "e5182b41a9272283bf4b60e3ba8089e45ec3a4d03962f93437acf69fddf116fb" => :catalina
    sha256 "f347e8be9160164414b050afbc703ceca8c76acb693839464488b5bfb0237085" => :mojave
    sha256 "35e8c854759ebcd3abd073d820f3ce92e2c5aa5a64dfa2f28211f19b23d37650" => :high_sierra
  end

  head do
    url "https://dev.monetdb.org/hg/MonetDB", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "libatomic_ops" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"
  depends_on "readline" # Compilation fails with libedit

  def install
    ENV["M4DIRS"] = "#{Formula["gettext"].opt_share}/aclocal" if build.head?
    system "./bootstrap" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--enable-assert=no",
                          "--enable-debug=no",
                          "--enable-optimize=yes",
                          "--enable-testing=no",
                          "--with-readline=#{Formula["readline"].opt_prefix}",
                          "--disable-rintegration"
    system "make"
    system "make", "install"
  end

  test do
    # assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
    system("#{bin}/monetdbd create #{testpath}/dbfarm")
    assert_predicate testpath/"dbfarm", :exist?
  end
end
