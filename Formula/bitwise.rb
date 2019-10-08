class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.40/bitwise-v0.40.tar.gz"
  sha256 "d74585153d8ae605fd9bb23d2a4b57ed5df283f902d376d0d31ade95423afa03"

  bottle do
    cellar :any
    sha256 "c78b42bffab47e12d4c98d97c47e14e9809e08fce3921cef84ae7f038fb1159a" => :mojave
    sha256 "0a3bd971b0473b8f863158df2f7176eb90b1da390840e43433f660bd62e006da" => :high_sierra
    sha256 "5b63274d741baf311a5e7409d42e5e63854ac5e5852c12e5ee08ba98572393d1" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    assert_match "0 0 1 0 1 0 0 1", shell_output("#{bin}/bitwise --no-color '0x29A >> 4'")
  end
end
