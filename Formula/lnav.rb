class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.5/lnav-0.8.5.tar.gz"
  sha256 "bb809bc8198d8f7395f3de76efdc1a08a5c2c97dc693040faee38802c38945de"

  bottle do
    cellar :any_skip_relocation
    sha256 "b888a423afd1868ef45428afc107f5fe7a9df3204330dc4f589a8e9acffaa14d" => :mojave
    sha256 "2d2a97a3c86fe5e16dd0579185fdb24151abb881c9415872875708b2e8e75be6" => :high_sierra
    sha256 "a1bd07d7c2cb1c08f8b894e994cf17e65d7ebcf2d10b39d34d643bfbb3b4f5ce" => :sierra
  end

  head do
    url "https://github.com/tstack/lnav.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "re2c" => :build
  end

  depends_on "pcre"
  depends_on "readline"
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

  test do
    system "#{bin}/lnav", "-V"
  end
end
