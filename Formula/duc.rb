class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.4/duc-1.4.4.tar.gz"
  sha256 "f4e7483dbeca4e26b003548f9f850b84ce8859bba90da89c55a7a147636ba922"
  head "https://github.com/zevv/duc.git"

  bottle do
    cellar :any
    sha256 "30af4be0a1a79ff03c09a550fe3a53fdce4c9e0ff99bd157ceec57648b740da7" => :mojave
    sha256 "3bd2b3086bc7646eea0d0d688f692ecaad61a0bb9f1795dfe41b5ef7d282ca35" => :high_sierra
    sha256 "d05ea4b58cb7e668444b1494cc78b1c00e4e7c2c6ddd3e8f5791411d75f2e03a" => :sierra
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
