class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-4.3.tar.gz"
  sha256 "92040ae842f7b8942d5cf26d8f58702a8d84c40a1fd492b415bd01b622bf372d"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e137cfa7c09c18dbf8f0badbfdff6b71706c47a9c151e4c42cd1b167508aa98" => :catalina
    sha256 "2f3245772f2d5f05f097646321b6da822a6ef794020973ca97fc6b1927cdf0e0" => :mojave
    sha256 "e9ab21895bee45f3530e1ed74be9b64b8fa3a92bc1fdde4491c3511f11a1f60a" => :high_sierra
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
  end
end
