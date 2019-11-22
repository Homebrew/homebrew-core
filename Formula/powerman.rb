class Powerman < Formula
  desc "Control (remotely and in parallel) switched power distribution units"
  homepage "https://code.google.com/p/powerman/"
  url "https://github.com/chaos/powerman/releases/download/2.3.25/powerman-2.3.25.tar.gz"
  sha256 "36e98a5a6b1395d8243b5bcaa8a6af42b4ab9411a63d7aa0768b4014ee0f207d"

  bottle do
    sha256 "501c8bb80bf0f5876e7464e3d26c80c45e8afaa14d630f8275144ba656e63bbb" => :catalina
    sha256 "1a36b88991905a9f768f789b9d4381d5ad26992259440325fc997bc3bcd074bd" => :mojave
    sha256 "397248285300786311331cfa9b67d74e0f3b1dfb9d93bc9d0887b7caa253bf3e" => :high_sierra
    sha256 "8eb522e26039405245bb5159c34eb8e329683569c0b0f6654aeed183d0f13dba" => :sierra
  end

  head do
    url "https://github.com/chaos/powerman.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "curl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--with-httppower",
                          "--with-ncurses",
                          "--without-genders",
                          "--without-snmppower",
                          "--without-tcp-wrappers"
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
