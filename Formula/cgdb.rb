class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.6.8.tar.gz"
  sha256 "be203e29be295097439ab67efe3dc8261f742c55ff3647718d67d52891f4cf41"
  revision 1

  bottle do
    sha256 "c438d3998dc56bbc7a1fc575ff7a57642f17a29a9e490ef096ece9b33ce8311c" => :sierra
    sha256 "c2f4e09bac94c7be9fa3fb5eac9d6291eaf1abd7d966a3db52923fce59bb3e37" => :el_capitan
    sha256 "5721a405b963337e70d27a400aa76443771ba660df9616c4a2ac918f3430242b" => :yosemite
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
end
