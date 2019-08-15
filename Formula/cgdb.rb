class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.7.1.tar.gz"
  sha256 "bb723be58ec68cb59a598b8e24a31d10ef31e0e9c277a4de07b2f457fe7de198"

  bottle do
    sha256 "8f361fcad59ddf4825f4d42b516a099ba75bfffc0b885d42aeb875dbd1b2a1d4" => :mojave
    sha256 "9ab4c0a880cb71903094929b04eada3c279a48ddb00b651a8a93d55cd523d380" => :high_sierra
    sha256 "db6c63b20e2185ecaaf3ddef92d1ff052f0b0322c727f3f0429ef0d38ac9d269" => :sierra
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
