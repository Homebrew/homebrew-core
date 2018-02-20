class Lnav < Formula
  desc "Curses-based tool for viewing and analyzing log files"
  # lnav.org has an SSL issue: https://github.com/tstack/lnav/issues/401
  homepage "https://github.com/tstack/lnav"
  url "https://github.com/tstack/lnav/releases/download/v0.8.3/lnav-0.8.3.tar.gz"
  sha256 "33808b07f6dac601b57ad551d234b30c8826c55cb8138bf221af9fedc73a3fb8"

  bottle do
    sha256 "cba3ec43a680bbafb94a76111b677cfbef2aa1e5c0d97bd0b9b954213c6daf15" => :high_sierra
    sha256 "6d10c74d64d4ea6ad0bf1e28feb03081164f6466984b18b1f35426c4b65ecf98" => :sierra
    sha256 "a9517f28d9765a56c5012726e392ac577de272b7a7c5dc998b66d20873e56271" => :el_capitan
    sha256 "d24c2db2e9a8954fb01326e458281699f1d8609bbdd99a0505967d5102aea0bc" => :yosemite
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
