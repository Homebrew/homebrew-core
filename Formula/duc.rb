class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.4/duc-1.4.4.tar.gz"
  sha256 "f4e7483dbeca4e26b003548f9f850b84ce8859bba90da89c55a7a147636ba922"
  revision 1
  head "https://github.com/zevv/duc.git"

  bottle do
    cellar :any
    sha256 "a6482213346ed6dfb26066b3442722a856cb8348d6123aecfe72929251e6b20a" => :mojave
    sha256 "d74b95c03260c0b14fd85e296835047bd88dbbc2f4fd0d62dc3a43409178c18c" => :high_sierra
    sha256 "9bde89536984080777e870473934584417fb4c34a0e44074b08a07a5db1a98d2" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glfw"
  depends_on "pango"
  depends_on "tokyo-cabinet"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-x11",
                          "--enable-opengl"
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=test", "count=1"
    system "#{bin}/duc", "index", "."
    system "#{bin}/duc", "graph", "-o", "duc.png"
    assert_predicate testpath/"duc.png", :exist?, "Failed to create duc.png!"
  end
end
