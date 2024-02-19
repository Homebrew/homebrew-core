class Libspelling < Formula
  desc "Spellcheck library for GTK 4"
  homepage "https://gitlab.gnome.org/chergert/libspelling"
  url "https://gitlab.gnome.org/chergert/libspelling/-/archive/0.2.0/libspelling-0.2.0.tar.bz2"
  sha256 "5ec7852d8e27f0dad3b1b6fcb49b1fe5d33aa74cc12d6366e2f84efec05e925c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "7b1e4294e1d6226a6b57be78e11817c6dfec208034853b30c70f1f29c9655ab3"
    sha256 cellar: :any, arm64_ventura:  "4caa410f3394eb0f4b9da158b2a7e6b9c782b011080a9267f93b208b49330857"
    sha256 cellar: :any, arm64_monterey: "36effae113060fbe6fc751774e8ce8be43b8224ae05f3aa661c07f5249c39313"
    sha256 cellar: :any, sonoma:         "137fed7418a3656ae2c0bfef6a81e94979a3dcc70cfb46ce0613d3185c2f1f0c"
    sha256 cellar: :any, ventura:        "38c34951b53522429b298bd2c158336949962b4bae8e58c425d648a2f5931db3"
    sha256 cellar: :any, monterey:       "4e895b5904eb9a84b1577ed393046f176af3dce085875c6a5de62c61e24ce9db"
    sha256               x86_64_linux:   "a5d27108f86227be1fbe29b9a6fcc4cdfde4c0b2c4ee4dc3dfcc21b3bf5832f4"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "enchant"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtksourceview5"

  def install
    system "meson", "setup", "build", "-Ddocs=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspelling.h>

      int main(int argc, char *argv[]) {
        SpellingChecker *checker = spelling_checker_get_default();
        return 0;
      }
    EOS

    pkg_config_cflags = shell_output("pkg-config --cflags --libs libspelling-1").chomp.split
    system ENV.cc, "test.c", *pkg_config_cflags, "-o", "test"
    system "./test"
  end
end
