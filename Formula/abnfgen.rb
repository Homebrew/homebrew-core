class Abnfgen < Formula
  desc "Quickly generate random documents that match an ABFN grammar"
  homepage "http://www.quut.com/abnfgen/"
  url "http://www.quut.com/abnfgen/abnfgen-0.20.tar.gz"
  sha256 "73ce23ab8f95d649ab9402632af977e11666c825b3020eb8c7d03fa4ca3e7514"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1531bab58a352221fca0cc5b73db2d9f206e1b98272ff06a90d72aa9e991925" => :catalina
    sha256 "b553651b5500f66d10a369f4d8862ed9c6d2b39d395c43e372b346b4c7bfead0" => :mojave
    sha256 "3a62e72bec09b9bfff637710db366f713abc95de45437aeadbfa87a87dfc040c" => :high_sierra
    sha256 "0d69f39473838a8e46fb02009329e05be6eeaed579ff5533a09cbbecd8d46a2d" => :sierra
    sha256 "fd51cb760ed8afb8a9e3dd5d05c8efa832361b238ad95410fb2864c91c081825" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"grammar").write 'ring = 1*12("ding" SP) "dong" CRLF'
    system "#{bin}/abnfgen", (testpath/"grammar")
  end
end
