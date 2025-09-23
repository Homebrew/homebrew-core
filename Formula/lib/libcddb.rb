class Libcddb < Formula
  desc "CDDB server access library"
  homepage "https://libcddb.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libcddb/libcddb/1.3.2/libcddb-1.3.2.tar.bz2"
  sha256 "35ce0ee1741ea38def304ddfe84a958901413aa829698357f0bee5bb8f0a223b"
  license "LGPL-2.0-or-later"
  revision 4

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:    "6324ea57171157edaca9aa78bbc30d5bc2389a5b9357bd8929a71bbdb7800720"
    sha256 cellar: :any,                 arm64_sequoia:  "eef9f2fe8b5a7994d21a6b2f53103e6a85b116c94c5f7bf69aa1f990a14c30d5"
    sha256 cellar: :any,                 arm64_sonoma:   "a12e153d3e00e99bbd7ccde361edd5ae2a1bf7aba9fa24c86478181d246385a8"
    sha256 cellar: :any,                 arm64_ventura:  "6955c8dbcc4de9ca756070ac11c0ea5da3d873f974d53b477bda94a09835f388"
    sha256 cellar: :any,                 arm64_monterey: "f12def876ae4aef3aed938fea3342da5eefd80ee164c05926b4bac8b7ea9d93a"
    sha256 cellar: :any,                 arm64_big_sur:  "5c01ee6149ed61a23ad7d8a2c09250fedf3b605638552fe82057cf77b0ac61f1"
    sha256 cellar: :any,                 sonoma:         "ffd7868a8476a26e39995963a2732f1b9737052a0b6e3c4bb18bfee923617742"
    sha256 cellar: :any,                 ventura:        "6756f179196e583816d73f558fe1dcf52a98406895d4f8402b51e993f49d3bd9"
    sha256 cellar: :any,                 monterey:       "134c99dc37719b7fbb915c17afcc5e9f08256ba2ecd295f3f0375d69f764dd8e"
    sha256 cellar: :any,                 big_sur:        "e19fbf67a440482346f40076ceae29a8b72590ef1376e6c5454d9f7814984e3b"
    sha256 cellar: :any,                 catalina:       "ca3cb9caeed526ef59a167293871d7b739c2ee6271571225dd1640f4af101140"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2f420c361caf0d48657e9f488aab6fcb7abc5929b7c24e05494952b2c24bcb44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a96b2ab16f2b983fa13921bc81d7b368a594620efd857d84ee8fb1667a18799d"
  end

  depends_on "pkgconf" => :build
  depends_on "libcdio"

  def install
    args = []
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <cddb/cddb.h>
      int main(void) {
        cddb_track_t *track = cddb_track_new();
        cddb_track_destroy(track);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lcddb", "-o", "test"
    system "./test"
  end
end
