class Nudoku < Formula
  desc "Ncurses based sudoku game"
  homepage "https://jubalh.github.io/nudoku/"
  url "https://github.com/jubalh/nudoku/archive/refs/tags/3.0.0.tar.gz"
  sha256 "56c9f8d70ca350411dccfdc5a0e2dc39aaa83da08f87ad874f7f4b7fb64b3541"
  license "GPL-3.0-or-later"
  head "https://github.com/jubalh/nudoku.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "85ce667fde814b7ca2b8c3144c1a81947c899e9f091bf90805cf77bdec0f4c9c"
    sha256 arm64_ventura:  "df24e16774377f98521d6bc623460dbe8a1340afdf08486f27c060b3911b37ed"
    sha256 arm64_monterey: "aaba4315a0bcaa31e2fbb6f667e49a04e80078bd43dec4b5c706f30f5954c054"
    sha256 sonoma:         "b557d8370bc5be84244ba9ec0ece988b92f83110bf58e2f4a68208da3bfb5013"
    sha256 ventura:        "e2a099b569c0f32ec86d4827962661af24c6e739fa33e416e46b6065744ecea6"
    sha256 monterey:       "b1f68424a9e2847b7e420ca03caa73fc523f64203d6619da8a17da1aa89cfbc8"
    sha256 x86_64_linux:   "dafd045886518df5e1eda43914636403c31a5e48a4c090a08df33bbab8573730"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gettext"

  uses_from_macos "ncurses"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-cairo",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "nudoku version #{version}", shell_output("#{bin}/nudoku -v")
  end
end
