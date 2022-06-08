class Gaul < Formula
  desc "Genetic Algorithm Utility Library"
  homepage "https://gaul.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/gaul/gaul-devel/0.1850-0/gaul-devel-0.1850-0.tar.gz"
  sha256 "7aabb5c1c218911054164c3fca4f5c5f0b9c8d9bab8b2273f48a3ff573da6570"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 monterey:        "4541d4d7d5d7ef43cc1acf3c57516e67fecf69e12f455f944d0a326816c400cd"
    sha256 cellar: :any,                 big_sur:         "e6a64a500ac22aec1a76616d86ea2f70449dfa30d37543faf9a135c2f98e1a07"
    sha256 cellar: :any,                 catalina:        "f2f98c2f7d23ae7c1862702c6d17d4449bbcc2164940d9157ea12b97deadb273"
    sha256 cellar: :any,                 mojave:          "0f60116cbca6bb8986ffbd291d34a22c6426ad4c22bcedca2873aa24ab237eeb"
    sha256 cellar: :any,                 high_sierra:     "f1b6b4fedb8820b14b6384d612b16a1acca71efa26a0d81881c1730720518765"
    sha256 cellar: :any,                 sierra:          "5dcd424881f8395070bf534b8bd480279a17cbf8a5784ba2be7dffdbfbc85f51"
    sha256 cellar: :any,                 el_capitan:      "0a6fb9c8ae17bb0785cc9c9da0fa0b3bf5fd6ca69b1ef8516b800d0d28d77360"
    sha256 cellar: :any,                 x86_64_yosemite: "8b0cb8b79f456faf4b7a8f9af2c788290b3e2eb1785f120875f2b72b4159fbf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:    "86d80af0c4bdef2186dccac01b0046ca2ca2c81c484b7c5f279553b2e190b53c"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    # Run autoreconf on macOS to rebuild configure script so that it doesn't try
    # to build with a flat namespace.
    system "autoreconf", "--force", "--verbose", "--install" if OS.mac?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--disable-g",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
