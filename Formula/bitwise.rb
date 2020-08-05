class Bitwise < Formula
  desc "Terminal based bit manipulator in ncurses"
  homepage "https://github.com/mellowcandle/bitwise"
  url "https://github.com/mellowcandle/bitwise/releases/download/v0.41/bitwise-v0.41.tar.gz"
  sha256 "33ce934fb99dadf7652224152cc135a0abf6a211adde53d96e9be7067567749c"

  bottle do
    cellar :any
    sha256 "d7d90a1402b7b87e1989b2504e6c55ea5bea27282f4bf909b6248aac2d5263cd" => :catalina
    sha256 "95674ac94d09b5502765956cc94b5f1a9687f22f145e2757bd708f7f7613f913" => :mojave
    sha256 "e5e76e2ec3f762a6c79b52552fb5513bc891e55831aa75806f61b75834369d6d" => :high_sierra
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
