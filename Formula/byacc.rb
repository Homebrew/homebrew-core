class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "https://invisible-island.net/byacc/"
  url "https://invisible-mirror.net/archives/byacc/byacc-20180609.tgz"
  sha256 "5bbb0b3ec3da5981a2488383b652499d6c1e0236b47d8bac5fcdfa12954f749c"

  bottle do
    cellar :any_skip_relocation
    sha256 "f58b641379028ef74139e38d8f1e69fe822de4a2d7730e444029938006f10c86" => :high_sierra
    sha256 "1a5be8985b2b869d5fe9959da4f453966c8aacb2c40a36abf8e0b8c84ec3ec50" => :sierra
    sha256 "a0061f52669ee96a39ecdd767b57465e041928a05f59d72a663a89051aa71faa" => :el_capitan
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
