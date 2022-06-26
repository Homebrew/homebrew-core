class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libcddb/libcddb/1.3.2/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  revision 4

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "f12def876ae4aef3aed938fea3342da5eefd80ee164c05926b4bac8b7ea9d93a"
    sha256 cellar: :any,                 arm64_big_sur:  "5c01ee6149ed61a23ad7d8a2c09250fedf3b605638552fe82057cf77b0ac61f1"
    sha256 cellar: :any,                 monterey:       "134c99dc37719b7fbb915c17afcc5e9f08256ba2ecd295f3f0375d69f764dd8e"
    sha256 cellar: :any,                 big_sur:        "e19fbf67a440482346f40076ceae29a8b72590ef1376e6c5454d9f7814984e3b"
    sha256 cellar: :any,                 catalina:       "ca3cb9caeed526ef59a167293871d7b739c2ee6271571225dd1640f4af101140"
    sha256 cellar: :any,                 mojave:         "534e9e7afc756a552c414b224d86ffa84c9966bbccf3a7d781a6b55a482e9bdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96b2ab16f2b983fa13921bc81d7b368a594620efd857d84ee8fb1667a18799d"
  end

  depends_on "pkg-config" => :build
  depends_on "libcdio"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <cddb/cddb.h>
      int main(void) {
        cddb_track_t *track = cddb_track_new();
        cddb_track_destroy(track);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lcddb", "-o", "test"
    system "./test"
  end
end
