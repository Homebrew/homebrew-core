class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.4/duc-1.4.4.tar.gz"
  sha256 "f4e7483dbeca4e26b003548f9f850b84ce8859bba90da89c55a7a147636ba922"
  head "https://github.com/zevv/duc.git"

  bottle do
    cellar :any
    sha256 "ba9af8cc944e89dcfe55e2dd081e49da64c68bdd6025516d8be0155319af652e" => :mojave
    sha256 "73b517bb32cbe3df05827770993ea8cfa721f9ac252878ad940fd3c45bebcdc8" => :high_sierra
    sha256 "d8c89b0441c3d4b4321ad9c833d1ed91fa0ec7758e67d87ce44b656e75e1931d" => :sierra
    sha256 "cc192c66f235d906f672dc56984a5a3fadcf60823e4c8bf2195759fb048526a5" => :el_capitan
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
