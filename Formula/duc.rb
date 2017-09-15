class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "http://duc.zevv.nl"
  url "https://github.com/zevv/duc/releases/download/1.4.3/duc-1.4.3.tar.gz"
  sha256 "504810a1ac1939fb1a70bd25e492f91ea38bcd58ae0a962ce5d35559d7775e74"
  head "https://github.com/zevv/duc.git"

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
