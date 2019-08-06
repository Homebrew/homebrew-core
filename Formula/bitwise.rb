class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.33/bitwise-v0.33.tar.gz"
  sha256 "598a623d9befaf1e724d78406a93140c1fc05ba9526f11bee945d236a92572c8"

  bottle do
    cellar :any
    sha256 "ca1fe56e701f249f78cf606a418257c2e5ef39f7de2c6a4b8426b3dfc5a7ef5e" => :mojave
    sha256 "24c4effd91b4f596576ebb8f92966195233f353fd5dd2daf4f774b8e7eeccf50" => :high_sierra
    sha256 "787986ce6174a4a564ef8b63c2535a84c674fd0f6bcd2863f00eb3e9019d3ee2" => :sierra
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
