class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.7.0.tar.gz"
  sha256 "bf7a9264668db3f9342591b08b2cc3bbb08e235ba2372877b4650b70c6fb5423"

  bottle do
    sha256 "c2da299ad0559c7c6cd8a4782bef9856ad84d09c2333d9e7c0f7342aab2ccb35" => :mojave
    sha256 "03ab0851b336b8f22b310f13774bd4737af6576f6732d116e4b8c7d1cf15ed0f" => :high_sierra
    sha256 "a81736f1e3b84ef7de58710b815bc90d845e4b5a0330146aca1fea31a75be81f" => :sierra
    sha256 "b2b8787372078b3d6568b232497a18da791c3197708f6814a69ced881d5c9055" => :el_capitan
    sha256 "4957746e9d5b84d9a39b07031ae1249d244bca262caf4ce84d744ddef8956c95" => :yosemite
  end

  head do
    url "https://github.com/cgdb/cgdb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/cgdb", "--version"
  end
end
