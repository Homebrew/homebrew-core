class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.3/lnav-0.8.3.tar.gz"
  sha256 "33808b07f6dac601b57ad551d234b30c8826c55cb8138bf221af9fedc73a3fb8"

  bottle do
    sha256 "9739f82778ae562845fb7a21166b8d235284b0b7c64fe41b9b99aba3aa4d79f4" => :high_sierra
    sha256 "7a689257734cdda57ec95ec3d0358062c3995c19eccd7836b094a249326a9d3a" => :sierra
    sha256 "db14f8c8d274575871d94396c4d81e6e8a0b56069051c82badf3d636a2dc44b9" => :el_capitan
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "readline"
  depends_on "pcre"
  depends_on "sqlite" if MacOS.version < :sierra

  def install
    # Fix errors such as "use of undeclared identifier 'sqlite3_value_subtype'"
    ENV.delete("SDKROOT")

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end
end
