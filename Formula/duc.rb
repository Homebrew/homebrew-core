class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "http://duc.zevv.nl"
  url "https://github.com/zevv/duc/releases/download/1.4.3/duc-1.4.3.tar.gz"
  sha256 "504810a1ac1939fb1a70bd25e492f91ea38bcd58ae0a962ce5d35559d7775e74"
  head "https://github.com/zevv/duc.git"

  bottle do
    cellar :any
    sha256 "d20f23f3c9d90fead8d533bb8e8abe38a3d62d1cc76ab987b46152491beb7b6a" => :high_sierra
    sha256 "673fc24a339b7b43a2e7274e4caac236f98df6f610e17e49c7cf2cddbd30fb85" => :sierra
    sha256 "4fc4a61b05777a5c50e921351b7b923ec00c21b2cc81c16348b3f27d25044f82" => :el_capitan
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
