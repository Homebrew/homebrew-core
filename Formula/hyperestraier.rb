class Hyperestraier < Formula
  desc "Full-text search system for communities"
  homepage "https://fallabs.com/hyperestraier/"
  url "https://fallabs.com/hyperestraier/hyperestraier-1.4.13.tar.gz"
  sha256 "496f21190fa0e0d8c29da4fd22cf5a2ce0c4a1d0bd34ef70f9ec66ff5fbf63e2"

  bottle do
    cellar :any
    sha256 "4275d3ad552f225c5b686532d6cc2703481284fa73eaf3c5b35bc5551dc95761" => :mojave
    sha256 "f0eeb8e60dc0639fdbf5c15fc22c954a627b5136525021706876972b5bfdd816" => :high_sierra
    sha256 "c6018d888e9a4f03546f1727d9ec7b6d7eb6a87fc4f6755667bdafa71929aca7" => :sierra
    sha256 "c90ef2d3ccac1af3247726697be33748ec53df85a98af4611b6dbfc9a8dca0c7" => :el_capitan
    sha256 "d18c19a9d691e2bd209cc05006b608776066352d297865238cc7262a527a82bd" => :yosemite
    sha256 "b52c716897730a939ba7763492b7b1080a70c918b07571f4a4e296aea42f42ee" => :mavericks
  end

  depends_on "qdbm"

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "mac"
    system "make", "check-mac"
    system "make", "install-mac"
  end

  test do
    system "#{bin}/estcmd", "version"
  end
end
