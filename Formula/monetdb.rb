class Monetdb < Formula
  desc "Column-store database"
  homepage "https://www.monetdb.org/"
  url "https://www.monetdb.org/downloads/sources/Nov2019/MonetDB-11.35.3.tar.xz"
  sha256 "54715eb6e33e1c9464c700cb30e143e00e549c344f410e1e424bbc61fea587cc"

  bottle do
    sha256 "0ffd1a63c20ce00c8113dc34ee913955bbd8e15138cdea416743aca1fe219073" => :catalina
    sha256 "5fc587bb69fc5afe4e8098ac567e7051d548aa1939b75d7f07473e5523dd5796" => :mojave
    sha256 "e6a219d572aa268ebe14eedef4a5fadb8722a35654e5a33d622ce801e0631940" => :high_sierra
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
    assert_match "Usage", shell_output("#{bin}/mclient --help 2>&1")
  end
end
