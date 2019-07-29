class Gaul < Formula
  desc "Genetic Algorithm Utility Library"
  homepage "https://gaul.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz"
  sha256 "7aabb5c1c218911054164c3fca4f5c5f0b9c8d9bab8b2273f48a3ff573da6570"

  bottle do
    cellar :any
    sha256 "0f60116cbca6bb8986ffbd291d34a22c6426ad4c22bcedca2873aa24ab237eeb" => :mojave
    sha256 "f1b6b4fedb8820b14b6384d612b16a1acca71efa26a0d81881c1730720518765" => :high_sierra
    sha256 "5dcd424881f8395070bf534b8bd480279a17cbf8a5784ba2be7dffdbfbc85f51" => :sierra
    sha256 "0a6fb9c8ae17bb0785cc9c9da0fa0b3bf5fd6ca69b1ef8516b800d0d28d77360" => :el_capitan
    sha256 "8b0cb8b79f456faf4b7a8f9af2c788290b3e2eb1785f120875f2b72b4159fbf5" => :yosemite
    sha256 "2ce7947353b3ea8e9be3925b1e516c92cbcca5602039d91ebe729c6fb96f5a37" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-g",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
