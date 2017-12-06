class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha256 "2cec51efa0c8d65ace8b21eaa08384b77abc5087b46e785f78de1c21fb754cd5"
  revision 1

  bottle do
    cellar :any
    sha256 "1a78a65920384f74c126fcc1b0dd50d32050e624b31c13832258e25c8ddeeb85" => :high_sierra
    sha256 "3574212320ef541e098198f1465cca7162cb59daff416af2190127d948a119eb" => :sierra
    sha256 "f96ca1b1429b412a1cdd65347cf84572f2904ac70c60dfacf88235861a7237e7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "lua"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end
end
