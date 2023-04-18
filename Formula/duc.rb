class Duc < Formula
  desc "Suite of tools for inspecting disk usage"
  homepage "https://duc.zevv.nl/"
  url "https://github.com/zevv/duc/releases/download/1.4.5/duc-1.4.5.tar.gz"
  sha256 "c69512ca85b443e42ffbb4026eedd5492307af612047afb9c469df923b468bfd"
  license "LGPL-3.0"
  head "https://github.com/zevv/duc.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f84fa8689d44e453cc7795e284c4bb33b5406f57e7e3e49dea18eed1e9853269"
    sha256 cellar: :any,                 arm64_monterey: "672f0a2f6ce1dd2ce3eac59e247af247c254ffac22b962f0931e3c637aede1e7"
    sha256 cellar: :any,                 arm64_big_sur:  "d70515b63c95de8ae52fb7e8ca11ef6fb6f98c1ab0661b4ce452fce2907cd35a"
    sha256 cellar: :any,                 ventura:        "e6e560263c0fe5805daa0d4a7acde5480d3607807d63a1b626d17ad83b5ac0b7"
    sha256 cellar: :any,                 monterey:       "36c158318b3407f306c82914ba1d63d9492c39644ae0ef1ad627ea20ef38351b"
    sha256 cellar: :any,                 big_sur:        "4c95e3a0b2a6222344c157b9a12a26cb9ee78a447788f124a8eb8d9968368779"
    sha256 cellar: :any,                 catalina:       "cc7f8ef4f7d6b1f310786032f0fab27aab42e17d57ee9393098f09e8b019cf50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8068dbd6bfa637aa4718113cff03ce8f8b641e65a379f489827b8acd3411f0e8"
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
    db_file = testpath/"duc.db"
    touch db_file
    system "dd", "if=/dev/zero", "of=test", "count=1"
    system "#{bin}/duc", "index", "-d", db_file, "."
    system "#{bin}/duc", "graph", "-d", db_file, "-o", "duc.png"
    assert_predicate testpath/"duc.png", :exist?, "Failed to create duc.png!"
  end
end
